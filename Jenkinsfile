pipeline {
    agent any

    parameters {
        text(name: 'bundle_version', description: '');
        text(name: 'oblac_drives_version', defaultValue: 'latest');
        text(name: 'motion_master_version', defaultValue: 'latest');
        text(name: 'motion_master_bridge_version', defaultValue: 'latest');
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
                ansiblePlaybook playbook: 'aws.yml'
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
