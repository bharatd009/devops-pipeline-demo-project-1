node {

  try {

    stage 'Checkout'
    checkout scm

    def branch = env.BRANCH_NAME

    print "Current branch ${branch}"

    if (branch == "master") {
      def build = load "jenkins/masterBuild.groovy"
      build.masterBuild();
    }

    if (branch != "master") {
      def build = load "jenkins/defaultBuild.groovy"
      build.defaultBuild();
    }

  } catch (err) {

    def utils = load "jenkins/utils.groovy"
    utils.failSlack()

    throw err

  } finally {
    stage 'Shutdown'
    sh "docker rmi \$(docker images -q)  &> /dev/null || true"
    sh "${compose} down -v"
    sh "docker rm \$(docker ps -a -q) &> /dev/null || true"
  }
}
