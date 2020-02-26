pipeline {
    agent any

    parameters {
        password(name: 'AWS_ACCESS_KEY_ID', defaultValue: 'SECRET', description: 'ACCESS KEY for AWS account')
        password(name: 'AWS_SECRET_ACCESS_KEY', defaultValue: 'SECRET', description: 'SECRET ACCESS KEY for AWS account')
    }

    stages {
	stage('Set Terraform path') {
 		steps {
 			script {
 				def tfHome = tool name: 'Terraform'
 				env.PATH = "${tfHome}:${env.PATH}"
 			}
 			sh 'terraform — version'
 
 
 			}
 	}		
 
 	stage('Provision infrastructure') {
 		steps {
 			dir('dev')
 			{
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
