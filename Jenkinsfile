pipeline {
    agent any
    
    triggers {
        githubPush() // Trigger the pipeline on GitHub push events
    }

    environment {
        // Define variables as needed
        DOCKER_IMAGE_NAME = "mox-test"
        REMOTE_SERVER = "98.70.91.102"
        //REMOTE_DIRECTORY = "/home/devops/${BUILD_ID}" // Create a unique directory for each build
        REMOTE_DIRECTORY = "/home/devops/mox"
    }

    // triggers {
    //     pollSCM('* * * * *') // Poll every minute, you can adjust as needed
    // }

    stages {
        stage('Build and Run Docker Container on Remote Server') {
            // agent {
            //     label 'devops-test'
            // }

            steps {
                script {
                    // Checkout your code from version control on the remote server
                    sshagent(['your-ssh-credentials-id']) {
                        // Delete the directory if it exists
                        sh "ssh -o StrictHostKeyChecking=no devops@${REMOTE_SERVER} 'if [ -d ${REMOTE_DIRECTORY} ]; then rm -rf ${REMOTE_DIRECTORY}; fi'"
                        // Create the directory
                        sh "ssh -o StrictHostKeyChecking=no devops@${REMOTE_SERVER} 'mkdir -p ${REMOTE_DIRECTORY}'"
                        // Clone repository into the directory and build Docker container
                        sh "ssh -o StrictHostKeyChecking=no devops@${REMOTE_SERVER} 'git clone https://github.com/akshayraina999/node-hello.git ${REMOTE_DIRECTORY}/hello-node && cd ${REMOTE_DIRECTORY}/hello-node && docker build -t ${DOCKER_IMAGE_NAME} .'"
                        // Stop and remove the previous container if it exists
                        sh "ssh -o StrictHostKeyChecking=no devops@${REMOTE_SERVER} 'docker stop ${DOCKER_IMAGE_NAME}_container && docker rm ${DOCKER_IMAGE_NAME}_container || true'"
                        // Spin up the new container
                        sh "ssh -o StrictHostKeyChecking=no devops@${REMOTE_SERVER} 'docker run -d --name ${DOCKER_IMAGE_NAME}_container -p 8080:80 ${DOCKER_IMAGE_NAME}'"
                    }
                }
            }
        }
    }

    post {
        success {
            // Additional post-build actions if needed
            echo "Docker image built successfully on the remote server, and the container is running!"
        }

        failure {
            // Actions to take in case of failure
            echo "Build or deployment failed"
        }
    }
}
