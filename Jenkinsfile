pipeline {
    agent any

    stages {
        stage('Setup') {
            steps {
                sh 'go mod tidy'
            }
        }
        stage('Lint') {
            steps {
                sh 'go vet ./...'
            }
        }
        stage('Test') {
            steps {
                sh 'go test -v -cover ./...'
            }
        }
        stage('Build') {
            steps {
                sh 'go build'
            }
        }
    }
}
