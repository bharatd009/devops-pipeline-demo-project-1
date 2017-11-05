def compose = "docker-compose -f docker-compose.yml -f docker-compose.test.yml"
def projectName = "votingapp"

pipeline {
  agent any
  options {
    timeout(time: 20, unit: 'MINUTES')
  }

  stages {
    stage('Checkout') {
      steps {
        notifyBuild('STARTED')
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh "${compose} -p ${projectName} build --pull"
      }
    }
  }

  post {
    always {
      sh "${compose} -p ${projectName} down -v"
    }
  }
}