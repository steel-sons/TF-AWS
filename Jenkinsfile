pipeline {
    agent any

    parameters {
        password(name: 'AWS_ACCESS_KEY_ID', defaultValue: 'SECRET', description: 'ACCESS KEY for AWS account')
        password(name: 'AWS_SECRET_ACCESS_KEY', defaultValue: 'SECRET', description: 'SECRET ACCESS KEY for AWS account')
    }

    environment {
        BUCKET_NAME           = "${STACK_NAME}-s3-tfstate"
        TF_STATE_FILE         = "${STACK_NAME}-terraform.tfstate"
    }

    stages {
        stage('Creating infrastructure.') {
            steps {
                script {
                    sh """
                        terraform init
                        sleep 60
                        terraform apply -auto-approve
                    """
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
