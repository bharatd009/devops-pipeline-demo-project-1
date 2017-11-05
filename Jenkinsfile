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

        // Push Docker Images
        sh "docker push allhaker/votingapp_frontend"
        sh "docker push allhaker/votingapp_backend"

        // Logout from Docker Registry
        sh "docker logout"
      }
    }

    stage('Tag and Push Docker Images to DockerHub') {
      when {
        expression { env.BRANCH_NAME == 'master' }
      }

      steps {
        def rancherHeaders = "-H 'Content-Type: application/json' -X POST"
        def rancherURL = 'http://192.168.50.4:8080/v1-webhooks/endpoint?key=rKL57M6PPe6HQqjlAAng0r8Ahi6sGGFPx2rDStq4&projectId=1a5'

        def rancherJSONFrontend = '{"push_data":{"tag":"development"},"repository":{"repo_name":"allhaker/votingapp_frontend"}}'
        def rancherJSONBackend = '{"push_data":{"tag":"development"},"repository":{"repo_name":"allhaker/votingapp_backend"}}'
        

        sh "curl ${rancherHeaders} -d '${rancherJSONFrontend}' '${rancherURL}'"
        sh "curl ${rancherHeaders} -d '${rancherJSONBackend}' '${rancherURL}'"
      }
    }
  }

  post {
    always {
      sh "${compose} down -v"
    }
  }
}