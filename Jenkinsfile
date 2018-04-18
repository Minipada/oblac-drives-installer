pipeline {
    agent any
    parameters {
        text(name: 'bundle_version', description: 'See the list of <a href="https://s3-eu-west-1.amazonaws.com/synapticon-tools/firmwares/odb.json" target="_blank">available bundles</a>. OBLAC Drives, Motion Master and Motion Master Bridge versions will be taken from dependencies property. Leave empty to build with the latest versions.');
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    stages {
        stage('Copy motion-master binary') {
            steps {
                copyArtifacts(projectName: 'motion-master/master');
                sh 'cp bin/motion-master roles/oblac-drives/files/opt';
            }
        }
        stage('Create OBLAC Drives VMs') {
            steps {
                ansiblePlaybook playbook: 'aws.yml', extraVars: [ bundle_version: params.bundle_version ]
            }
        }
    }
    post {
        unstable {
            mail to: 'msankovic@synapticon.com',
                subject: "Unstable Pipeline: ${currentBuild.fullDisplayName}",
                body: "Something is wrong with ${env.BUILD_URL}"
        }
        failure {
            mail to: 'msankovic@synapticon.com',
                subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
                body: "Something is wrong with ${env.BUILD_URL}"
        }
    }
}
