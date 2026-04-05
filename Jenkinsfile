pipeline {
    agent any

    environment {
        IMAGE_NAME = "go-ci-app"
        VERSION = "v1"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gowthae/jenkins-ci-tests.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$VERSION .
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker run --rm $IMAGE_NAME:$VERSION
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully 🚀"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}
