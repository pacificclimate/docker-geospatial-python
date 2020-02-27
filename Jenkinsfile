@Library('pcic-pipeline-library@1.0.0')_


node {
    stage('Code Collection') {
        collectCode()
    }

    def image
    def imageName = buildImageName('geospatial-python')

    stage('Build Image') {
        image = buildDockerImage(imageName)
    }

    stage('Publish Image') {
        publishDockerImage(image, 'PCIC_DOCKERHUB_CREDS')
    }

    if(BRANCH_NAME.contains('PR') || BRANCH_NAME == 'master') {
        stage('Security Scan') {
            writeFile file: 'anchore_images', text: imageName
            anchore name: 'anchore_images', engineRetries: '700'
        }
    }

    stage('Clean Local Image') {
        removeDockerImage(imageName)
    }

    stage('Clean Workspace') {
        cleanWs()
    }
}
