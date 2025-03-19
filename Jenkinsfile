pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'  // Replace with your AWS region
    }
    parameters {
        choice(name: 'action', choices: ['create', 'delete'], description: 'Choose create/destroy')
        
    }
    stages {
        stage('Checkout SCM') {
            when { expression { params.action == 'create' } }
            steps {
                sh '''
                    rm -rf Brainwave_Matrix_Intern
                    git clone https://github.com/Deepthi-123456789/Brainwave_Matrix_Intern.git
                '''
            }
        }
 

        stage('Validate Workspace') {
            steps {
                script {
                    sh '''
                    echo "Validating directory and Terraform files..."
                    cd Brainwave_Matrix_Intern/k8-eksctl
                    ls -al
                    '''
                }
            }
        }

        stage('Init') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                        sh """
                            cd Brainwave_Matrix_Intern/k8-eksctl
                            terraform init -reconfigure
                        """
                    
                }
            }
        }

        stage('Verify Terraform Files') {
            steps {
                script {
                    sh '''
                    echo "Checking contents of Brainwave_Matrix_Intern/k8-eksctl directory..."
                    cd Brainwave_Matrix_Intern/k8-eksctl
                    ls -al
                    '''
                }
            }
        }

        stage('Plan') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    
                        sh """
                            cd Brainwave_Matrix_Intern/k8-eksctl
                            terraform plan
                        """
                    
                }
            }
        }

        stage('Apply') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    
                        sh """
                            ls -al
                            cd Brainwave_Matrix_Intern/k8-eksctl
                            terraform apply -auto-approve
                        """
                    
                }
            }
        }

        // When destroying
        stage('Destroy') {
            when { expression { params.action == 'delete' } }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                        sh """
                            cd Brainwave_Matrix_Intern/k8-eksctl
                            terraform destroy -auto-approve
                        """
                    }
                }
            }
        }
        stage('Provision EKS Cluster') {
            when { expression { params.action == 'create' } }
            steps {
                dir('Brainwave_Matrix_Intern/k8-eksctl') {
                    script {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                            sh '''
                                # Provision the EKS cluster using eksctl
                                eksctl create cluster -f eks.yaml 
                            '''
                        }
                    }
                }
            }
        }

        stage('Deploying Nginx Application') {
            steps{
                script{
                    dir('web') {
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                    }
                }
            }
}
    }
    post {
        always {
            echo 'Pipeline completed.'
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
