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
                sh "docker pull ttl.sh/furkan-kocak:2h"
                sh "docker stop go-server || true"
                sh "docker rm go-server || true"
                sh "docker run -d -p 4444:4444 --name go-server ttl.sh/furkan-kocak:2h"
            }
        }
    }
}
