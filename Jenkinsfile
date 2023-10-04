pipeline {
    agent any

    environment {
        IMAGE_NAME = 'bibekbajagain/nodejs-todo'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Lint with ESLint') {
            steps {
                script {
                    sh 'npm install' // Install dependencies (including ESLint)
                    sh 'npx eslint . --fix' // Run ESLint and auto-fix issues
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
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

        stage('Deploy to DEV') {
            steps {
                script {
                    sh """
                        ssh -o StrictHostKeyChecking=no root@192.168.40.4 \
                        "docker pull $IMAGE_NAME && docker rm -f nice_clarke &&
                         docker run -d -p 3000:3000 $IMAGE_NAME"
                    """
                }
            }
        }
//deplo
        stage('Deploy to PROD') {
            steps {
                script {
                    def userInput = input(
                        id: 'userInput',
                        message: 'Deploy to PROD?',
                        ok: 'Deploy'
                    )
                    if (userInput == 'Deploy') {
                        sh """
                            ssh -o StrictHostKeyChecking=no root@192.168.40.4 \
                            "docker pull $IMAGE_NAME && docker rm -f nice_clarke &&
                             docker run -d -p 4000:4000 $IMAGE_NAME"
                        """
                    } else {
                        error 'Production deployment rejected by user.'
                    }
                }
            }
        }
    }
}
