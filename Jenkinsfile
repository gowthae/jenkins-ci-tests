pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_ACCOUNT = "" // leave empty for local learning, will be injected via Jenkins credentials if needed
        REPO_NAME = "go-ci-app"
        IMAGE_TAG = ""   // dynamically set per build
        LOCAL_REGISTRY = "localhost:5000" // optional local Docker registry for safe testing
    }

    stages {

        stage('Checkout') {
            steps {
                echo "🔄 Checking out repository..."
                git branch: "${env.BRANCH_NAME ?: 'main'}", url: 'https://github.com/gowthae/jenkins-ci-tests.git'
            }
        }

        stage('Set Image Tag') {
            steps {
                script {
                    // Use branch name + short Git commit as image tag
                    def commit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    IMAGE_TAG = "${env.BRANCH_NAME ?: 'main'}-${commit}"
                    echo "🏷 Docker image tag will be: ${IMAGE_TAG}"
                }
            }
        }

        stage('Verify Environment') {
            steps {
                echo "🔍 Checking Go, Docker, and AWS CLI..."
                sh '''
                go version || echo "Go is missing!"
                docker version || echo "Docker is missing!"
                aws --version || echo "AWS CLI is missing!"
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "📦 Installing Go dependencies..."
                sh 'go mod tidy'
            }
        }

        stage('Run Tests') {
            steps {
                echo "🧪 Running Go tests..."
                sh 'go test ./... -v -cover'
            }
        }

        stage('Build Go Binary') {
            steps {
                echo "⚙️ Building Go binary..."
                sh 'go build -o app'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                sh "docker build -t ${REPO_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Optional: Push to Local Registry') {
            steps {
                echo "🏗 Tagging and pushing image to local registry..."
                sh '''
                docker tag ${REPO_NAME}:${IMAGE_TAG} ${LOCAL_REGISTRY}/${REPO_NAME}:${IMAGE_TAG}
                docker push ${LOCAL_REGISTRY}/${REPO_NAME}:${IMAGE_TAG} || echo "Local registry not running, skipping"
                '''
            }
        }

        stage('Push Docker Image to ECR (Optional)') {
            when {
                expression { return env.ECR_ACCOUNT?.trim() }
            }
            steps {
                echo "🔑 Logging in to AWS ECR..."
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ECR_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com
                    '''
                }
                echo "🏷 Tagging Docker image for ECR..."
                sh "docker tag ${REPO_NAME}:${IMAGE_TAG} $ECR_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/${REPO_NAME}:${IMAGE_TAG}"
                echo "⬆️ Pushing Docker image to ECR..."
                sh "docker push $ECR_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/${REPO_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline finished successfully. Image tag: ${IMAGE_TAG}"
        }
        failure {
            echo "❌ Pipeline failed."
        }
        always {
            echo "🧹 Cleaning up Docker images..."
            sh 'docker system prune -f || true'
        }
    }
}
