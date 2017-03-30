import groovy.json.JsonOutput

compose = "docker-compose -f docker-compose.yml -f docker-compose.test.yml"
devServices = "frontend backend seed-db"
projectNameBase = "demo-project-"
rancherUrl = "http://192.168.50.4:8080/v2-beta"

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
        sh "docker push allhaker/votingapp_backend:${tag}"
        sh "docker push allhaker/votingapp_frontend:${tag}"
    }
}

def upgradeEnvironment(environment) {
    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '15736741-7880-434d-83b8-9c255ba8cd60',
                            accessKeyVariable: 'ACCESSKEY', secretKeyVariable: 'SECRETKEY']]) 
    {
        if (environment == 'development') {
            def rancherDev = "rancher-compose -f docker-compose.dev.yml -f rancher-compose.dev.yml --url ${rancherUrl}" +
                " --access-key ${ACCESSKEY} --secret-key ${SECRETKEY} -p ${projectNameBase}${environment} up -d"
            sh "${rancherDev} --force-upgrade --pull ${devServices}"
            sh "${rancherDev} --confirm-upgrade ${devServices}"
        }
    }
}

def seedDB() {
  sh "${compose} run mocha node db/seeds.js"
}

return this