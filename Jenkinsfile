pipeline {
    agent {
        docker {
            image 'golang:1.21'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = "go-ci-app"
        VERSION = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gowthae/jenkins-ci-tests.git'
            }
        }

        stage('Verify Environment') {
            steps {
                sh '''
                echo "Checking environment..."
                go version
                docker --version
                '''
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
                go test ./... -v
                '''
            }
        }

        stage('Build Binary') {
            steps {
                sh '''
                echo "Building Go binary..."
                go build -o app
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
        always {
            sh 'docker system prune -f || true'
        }
    }
}
