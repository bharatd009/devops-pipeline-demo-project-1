def compose = "docker-compose -f docker-compose.yml -f docker-compose.test.yml -p votingapp"

pipeline {
  agent any
  options {
    timeout(time: 20, unit: 'MINUTES')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh "${compose} build --pull"
      }
    }

    stage('Test Backend (Mocha)') {
      steps {
        sh "${compose} run mocha"
      }
    }
  }

  post {
    always {
      sh "${compose} down -v"
    }
  }
}