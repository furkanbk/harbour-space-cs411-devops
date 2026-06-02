pipeline {
    agent any

    tools {
       go "1.24.1"
    }

    environment {
        AWS_REGION = 'eu-north-1'
        TF_VAR_aws_region = 'eu-north-1'
    }

    stages {
        stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        cd terraform
                        terraform init
                        terraform plan -out=tfplan
                        terraform apply -auto-approve tfplan
                        terraform output -raw instance_public_ip > ../instance_ip.txt
                    '''
                }
            }
        }

        stage('Build') {
            steps {
                sh 'CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main main.go'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    env.PUBLIC_IP = readFile('instance_ip.txt').trim()
                }
                withCredentials([sshUserPrivateKey(credentialsId: 'AWS_SSH_KEY', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
chmod 600 "$SSH_KEY"

scp -o StrictHostKeyChecking=no -i "$SSH_KEY" \
    main ubuntu@"$PUBLIC_IP":/tmp/myapp

ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" ubuntu@"$PUBLIC_IP" 'bash -s' <<'REMOTE'
sudo useradd --system --no-create-home --shell /usr/sbin/nologin myapp 2>/dev/null || true
sudo mkdir -p /opt/myapp
sudo mv /tmp/myapp /opt/myapp/myapp
sudo chown -R myapp:myapp /opt/myapp
sudo chmod +x /opt/myapp/myapp

cat <<'SERVICEFILE' | sudo tee /etc/systemd/system/myapp.service > /dev/null
[Unit]
Description=MyApp Go Server
After=network.target

[Service]
Type=simple
User=myapp
Group=myapp
ExecStart=/opt/myapp/myapp
Restart=on-failure

[Install]
WantedBy=multi-user.target
SERVICEFILE

sudo systemctl daemon-reload
sudo systemctl enable myapp
sudo systemctl restart myapp
REMOTE
                    '''
                }
            }
        }
    }
}
