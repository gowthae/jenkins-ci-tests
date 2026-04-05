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

        stage('Install Dependencies') {
            steps {
                sh '''
                echo "Installing dependencies..."
                go mod tidy
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                echo "Running tests..."
                go test ./...
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                echo "Building Docker image..."
                docker build -t $IMAGE_NAME:$VERSION .
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                echo "Running container..."
                docker run --rm $IMAGE_NAME:$VERSION
                '''
            }
        }

    }

    post {
        success {
            echo "✅ Pipeline executed successfully"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
