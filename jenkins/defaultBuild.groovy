utils = load "jenkins/utils.groovy"

def defaultBuild() {
  stage 'Build Docker Images'
  utils.buildDocker()

  stage 'Seed Database'
  utils.seedDB()

  stage 'Test Backend (mocha)'
  utils.runMocha()
}

return this