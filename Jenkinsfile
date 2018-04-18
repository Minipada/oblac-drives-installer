pipeline {
    agent any
    parameters {
        text(name: 'bundle_version', description: 'The list of already released bundles: https://s3.amazonaws.com/oblac-drives/index.html');
        text(name: 'oblac_drives_version', defaultValue: 'latest');
        text(name: 'motion_master_version', defaultValue: '', description: 'Specify motion-master version from AWS S3 synapticon-tools/motion-master/release/ to download or if left empty copy a binary from the motion-master Jenkins job.');
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
                ansiblePlaybook playbook: 'aws.yml', extraVars: [
                    bundle_version: params.bundle_version,
                    oblac_drives_version: params.oblac_drives_version,
                    motion_master_version: params.motion_master_version,
                    motion_master_bridge_version: params.motion_master_bridge_version
                ]
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
