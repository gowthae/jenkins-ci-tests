pipeline {
    agent any

    stages {
        stage('Build & Test') {
            steps {
                sh 'go mod tidy'
                sh 'go test -cover ./...'
                sh 'go build'
            }
        }
    }
}
