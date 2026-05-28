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
        stage('Docker Build and Push') {
            steps {
                sh "docker build -t ttl.sh/furkan-kocak:2h ."
                sh "docker push ttl.sh/furkan-kocak:2h"
            }
        }
        stage('Kubernetes Deploy') {
            steps {
                withCredentials([string(credentialsId: 'SERVICE_ACCOUNT_TOKEN', variable: 'TOKEN')]) {
                    sh '''
                        cat <<'EOF' > pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: myapp
    image: ttl.sh/furkan-kocak:2h
    ports:
    - containerPort: 4444
    livenessProbe:
      httpGet:
        path: /
        port: 4444
    readinessProbe:
      httpGet:
        path: /
        port: 4444
EOF
                        kubectl apply -f pod.yaml \
                            --server=https://kubernetes:6443 --token=$TOKEN --insecure-skip-tls-verify=true
                    '''
                }
            }
        }
    }
}
