pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Python venv') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install flask
                '''
            }
        }

        stage('Run Microservice Test') {
            steps {
                sh '''
                chmod +x test_microservice.sh
                ./test_microservice.sh
                '''
            }
        }
    }
}
