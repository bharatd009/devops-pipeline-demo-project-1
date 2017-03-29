import groovy.json.JsonOutput

compose = "docker-compose -f docker-compose.yml -f docker-compose.test.yml"

def buildDocker() {
  sh "${compose} build"
}

def runMocha() {
  sh "${compose} run mocha"
}

def tagDockerImages(tag) {
  sh "docker tag votingapp_frontend:local allhaker/votingapp_frontend:${tag}"
  sh "docker tag votingapp_backend:local allhaker/votingapp_backend:${tag}"
}

def pushDockerImages(tag) {
    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'd1561356-160b-47fe-91a8-d7bd06b2b2d0',
                            usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) 
    {
        sh "docker login -u ${USERNAME} -p ${PASSWORD}"
        sh "docker push votingapp_backend:${tag}"
        sh "docker push votingapp_frontend:${tag}"
    }
}

def seedDB() {
  sh "${compose} run mocha node db/seeds.js"
}

return this