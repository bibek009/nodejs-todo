pipeline {
    agent any
    environment {
        IMAGE_NAME = 'bibekbajagain/nodejs-todo'
        VPS_SSH_CREDENTIALS = '1'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

  //      stage('Build and Test') {
  //          steps {
                //sh 'npm test'
  //          }
  //      }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using the specified Dockerfile
                    sh "docker build -t $IMAGE_NAME ."
                }
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: '2', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u bibekbajagain --password-stdin"
                    sh "docker push $IMAGE_NAME"
                }
            }
        }

        stage('Deploy to VPS') {
            steps {
                sshagent([credentials: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'your-ssh-credentials-id', usernameVariable: 'SSH_USERNAME', passwordVariable: 'SSH_PASSWORD']]]) {
                    sh "ssh $SSH_USERNAME@192.168.40.4 'docker pull $IMAGE_NAME && docker-compose up -d'"
                }
            }
        }
    }
}
