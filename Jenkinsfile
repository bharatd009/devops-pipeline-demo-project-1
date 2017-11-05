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

    stage('Tag and Push Docker Images to DockerHub') {
      when {
        expression { env.BRANCH_NAME == 'master' }
      }

      steps {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-login',
        usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
          // Login to Docker Registry
          sh "docker login -u ${USERNAME} -p ${PASSWORD}"
        }

        // Tag Docker Images
        sh "docker tag votingapp_frontend allhaker/votingapp_frontend"
        sh "docker tag votingapp_backend allhaker/votingapp_backend"

        // Logout from Docker Registry
        sh "docker logout"
      }
    }
  }

  post {
    always {
      sh "${compose} down -v"
    }
  }
}