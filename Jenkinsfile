pipeline {
    agent any

    tools {
       go "1.24.1"
    }

    stages {
        stage('Build') {
            steps {
                sh "go build main.go"
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'TARGET_SSH_KEY', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        chmod 600 "$SSH_KEY"

                        scp -o StrictHostKeyChecking=no -i "$SSH_KEY" main laborant@target:/tmp/myapp

                        ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" laborant@target 'bash -s' <<'REMOTE'
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
