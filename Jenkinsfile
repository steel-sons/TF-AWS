pipeline {
    agent any

    parameters {
        password(name: 'AWS_ACCESS_KEY_ID', defaultValue: 'SECRET', description: 'ACCESS KEY for AWS account')
        password(name: 'AWS_SECRET_ACCESS_KEY', defaultValue: 'SECRET', description: 'SECRET ACCESS KEY for AWS account')
    }
    environment {
       // moving to environment init
       // tfHome = tool name: 'terraform-0.12.16'
       tfHome = tool name: 'Terraform'
       PATH = "${tfHome}:${env.PATH}"
       // TERRAFORM_CONFIGURATION_GIT_PATH = '../jenkins-pipelines/cluster-configuration-terraform'
       }
    stages {
	      stage('Check Terraform initialization') {
 		        steps {
 			            sh 'terraform version'
 	          }
 	      }
        stage('Checkout SCM tool') {
            steps {
                   		checkout scm
                   		sh 'echo $AWS_ACCESS_KEY_ID'
                   		sh 'echo $AWS_SECRET_ACCESS_KEY'
                  }
              }
 	      stage('Provision infrastructure') {
 		        steps {
 				               sh 'terraform init'
 				               sh 'terraform plan -out=plan'
 				               // sh 'terraform destroy -auto-approve'
 				               sh 'terraform apply plan'

                       }
 	     }
    }
    post {
        always {
            cleanWs()
        }
    }
}
