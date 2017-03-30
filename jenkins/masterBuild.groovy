utils = load "jenkins/utils.groovy"

def masterBuild() {
  stage 'Build Docker Images'
  utils.buildDocker()

  stage 'Seed Database'
  utils.seedDB()

  stage 'Test Backend (mocha)'
  utils.runMocha()

  stage 'Push Docker Images to DockerHub (development)'    
  utils.tagDockerImages("development")
  utils.pushDockerImages("development")

  stage 'Upgrade Development Environment'
  utils.upgradeEnvironment("development")
}

return this