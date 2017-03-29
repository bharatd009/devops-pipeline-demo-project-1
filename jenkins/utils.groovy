import groovy.json.JsonOutput

compose = "docker-compose -f docker-compose.yml -f docker-compose.test.yml"

def buildDocker() {
  sh "${compose} build"
}

def runMocha() {
  sh "${compose} run mocha"
}

def seedDB() {
  sh "${compose} run mocha node db/seeds.js"
}

return this