utils = load "jenkins/utils.groovy"

def masterBuild() {
  stage 'Build Docker Images'
  utils.buildDocker()

  stage 'Seed Database'
  utils.seedDB()

  stage 'Test Backend (mocha)'
  utils.runMocha()

  // stage 'Push Docker Images to DockerHub (latest)'    
  // utils.pushDockerImagesToArtifactory("latest")

  // stage 'Upgrade Demo Environment'
  // utils.upgradeEnvironment("latest")
}

return this