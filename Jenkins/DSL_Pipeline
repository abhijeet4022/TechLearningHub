// Declarative Pipeline - V2 Code.
pipeline {
    agent { node { label 'workstation' } }

    options {
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }

    stages {
        stage('Compile') {
            steps {
                script {
                    // Add valid shell commands here
                    sh 'echo "Running compile stage"'
                    sh 'pwd'
                    sh 'ls -l'
                }
            }
        }

        stage('Build') {
            steps {
                echo "Hello World"
            }
        }

        stage('Test') {
            steps {
                echo "Test for pollSCM"
            }
        }
    }

    post {
        always {
            script {
                echo "Build finished"
                cleanWs()
            }
        }
    }
}
