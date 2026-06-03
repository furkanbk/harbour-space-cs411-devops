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
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'DOCKER_SSH_KEY', keyFileVariable: 'DOCKER_SSH_KEY')]) {
                    sh '''
                        ssh -i $DOCKER_SSH_KEY -o StrictHostKeyChecking=no laborant@docker \
                            "docker pull ttl.sh/furkan-kocak:2h && \
                             docker stop go-server || true && \
                             docker rm go-server || true && \
                             docker run -d -p 4444:4444 --name go-server ttl.sh/furkan-kocak:2h"
                    '''
                }
            }
        }
        stage('Test') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'DOCKER_SSH_KEY', keyFileVariable: 'DOCKER_SSH_KEY')]) {
                    sh '''
                        ssh -i $DOCKER_SSH_KEY -o StrictHostKeyChecking=no laborant@docker '
                            sleep 3
                            RESPONSE=$(wget -qO- http://localhost:4444/) || { echo "Health check failed: could not reach service"; exit 1; }
                            echo "Response: $RESPONSE"
                            echo "$RESPONSE" | grep -q "Name" || { echo "Missing Name"; exit 1; }
                            echo "$RESPONSE" | grep -q "Description" || { echo "Missing Description"; exit 1; }
                            echo "$RESPONSE" | grep -q "Url" || { echo "Missing Url"; exit 1; }
                            echo "Test passed: Service is healthy and returns expected JSON"
                        '
                    '''
                }
            }
        }
    }
}
