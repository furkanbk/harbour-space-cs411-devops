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
                        kubectl run myapp --image=ttl.sh/furkan-kocak:2h --dry-run=client -o=yaml \
                            --server=https://kubernetes:6443 --token=$TOKEN --insecure-skip-tls-verify=true > pod.yaml
                        kubectl apply -f pod.yaml \
                            --server=https://kubernetes:6443 --token=$TOKEN --insecure-skip-tls-verify=true
                    '''
                }
            }
        }
    }
}
