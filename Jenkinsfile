pipeline {
    agent any
    
    triggers {
        githubPush() // Trigger the pipeline on GitHub push events
    }

    environment {
        // Define variables as needed
        BUILD_NUMBER = env.BUILD_NUMBER.toInteger()  // Get the build number
        TAG_VERSION = "${(BUILD_NUMBER / 20) + 1}.${BUILD_NUMBER % 20 ?: 20}" // Calculate tag version
        DOCKER_IMAGE_NAME = "mox-test:${TAG_VERSION}" // Set Docker image name with dynamic tag
        // DOCKER_IMAGE_NAME = "mox-test"
        REMOTE_SERVER = "98.70.91.102"
        DOCKER_CONTAINER_NAME = "mox-backend"
        //REMOTE_DIRECTORY = "/home/devops/${BUILD_ID}" // Create a unique directory for each build
        REMOTE_DIRECTORY = "/home/devops/mox"
        // MESSAGE = "Build ${currentBuild.currentResult}: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
        BOT_TOKEN = '6778676572:AAF3HJETKhOQ5Jp0J1OfffNJp4q9cxwemQk'
        GOOGLE_CHAT_WEBHOOK = 'https://chat.googleapis.com/v1/spaces/AAAA6pJbA5A/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=bc1PFPONavXPbScSqKoeYmN95HgNTMx1o-C9zL4fnz0'
        CHAT_ID = '-4115461746'
        MESSAGE_SUCCESS = "✅ Build Successful: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
        MESSAGE_FAILURE = "❌ Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
    }

    // triggers {
    //     pollSCM('* * * * *') // Poll every minute, you can adjust as needed
    // }

    stages {
        // stage('Setup Node.js and npm') {
        //     steps {
        //         script {
        //             // Install Node.js and npm
        //             sh 'curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -'
        //             sh 'sudo apt-get install -y nodejs'

        //             // Verify Node.js and npm installation
        //             sh 'node -v'
        //             sh 'npm -v'
        //         }
        //     }
        // }
        
        // stage('SonarQube analysis') {
        // environment {
        //     scannerHome = tool 'sonar-server'
        // }
        // steps {
        //     withSonarQubeEnv('sonar-server') {
        //         sh '''
        //         ${scannerHome}/bin/sonar-scanner \
        //         -D sonar.projectKey=node-hello-test \
        //         -D sonar.projectName=node-hello \
        //         -D sonar.login=squ_4e738e91cc03be21239d3feeaeed4469be9c1e7b \
        //         -D sonar.projectVersion=1.0 \
        //         -D sonar.sources=. \
        //         -D sonar.host.url=http://98.70.91.102:9000 \
        //         -D sonar.test.inclusions=**/node_modules/**,/coverage/lcov-report/*,test/*.js
        //         '''
        //         }
        //     }
            // steps {
            //     script {
            //         withSonarQubeEnv('sonar-server') {
            //             sh "npm install sonar-scanner"
            //             sh "sonar-scanner \
                            // -D sonar.projectKey=sqp_e552dde081d43d5c7baf8798aa774230d5b7e53d \
            //                 -Dsonar.projectKey=node-hello \
            //                 -Dsonar.projectName=node-hello \
            //                 -Dsonar.projectVersion=1.0 \
            //                 -Dsonar.sources=. \
            //                 -Dsonar.host.url=http://98.70.91.102:9000 \
            //                 -Dsonar.login=sqp_e552dde081d43d5c7baf8798aa774230d5b7e53d"
            //         }
            //     }
            // }
            // steps {
            //     script {
            //         withSonarQubeEnv('sonar-server') {
            //             def nodejsHome = tool 'node18'
            //             sh "${nodejsHome}/bin/npm install sonar-scanner"
            //             sh "${nodejsHome}/bin/npm run sonar"
            //         }
            //     }
            // }
        //}
        
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
                        sh "ssh -o StrictHostKeyChecking=no devops@${REMOTE_SERVER} 'docker stop ${DOCKER_CONTAINER_NAME} && docker rm ${DOCKER_CONTAINER_NAME} || true'"
                        // Spin up the new container
                        sh "ssh -o StrictHostKeyChecking=no devops@${REMOTE_SERVER} 'docker run -d --name ${DOCKER_CONTAINER_NAME} -p 8080:80 ${DOCKER_IMAGE_NAME}'"
                    }
                }
            }
        }
    }

    // post {
    //     always {
    //         // Fetch SonarQube report
    //         script {
    //             // def scanner = SonarQube.qualityGate()
    //             def status = scanner['status']
    //             // def conditions = scanner['conditions']
    //             def projectName = scanner['node-hello']
    //             def projectVersion = scanner['1.0']
                
    //             // Example: Sending report via email
    //             // \nQuality Gate Status: ${status}\nConditions: ${conditions}
    //             emailext body: "Project Name: ${projectName}\nProject Version: ${projectVersion}",
    //                      subject: "SonarQube Analysis Report",
    //                      to: "akshayraina999@gmail.com"
    //         }
    //     }
        
    //     success {
    //         // Additional post-build actions if needed
    //         echo "Docker image built successfully on the remote server, and the container is running!"
    //     }

    //     failure {
    //         // Actions to take in case of failure
    //         echo "Build or deployment failed"
    //     }
    // }
    post {
                success {
                    script {
                        // sh "curl -s -X POST https://api.telegram.org/bot${env.BOT_TOKEN}/sendMessage -d chat_id=${env.CHAT_ID} -d text='${env.MESSAGE}'"
                        sh "curl -s -X POST https://api.telegram.org/bot${env.BOT_TOKEN}/sendMessage -d chat_id=${env.CHAT_ID} -d text='${env.MESSAGE_SUCCESS}'"
                        sh "curl -X POST -H 'Content-Type: application/json' -d '{\"text\": \"${env.MESSAGE_SUCCESS}\"}' ${GOOGLE_CHAT_WEBHOOK}"
                    }
                }
                failure {
                    script {
                        // sh "curl -s -X POST https://api.telegram.org/bot${env.BOT_TOKEN}/sendMessage -d chat_id=${env.CHAT_ID} -d text='${env.MESSAGE}'"
                        sh "curl -s -X POST https://api.telegram.org/bot${env.BOT_TOKEN}/sendMessage -d chat_id=${env.CHAT_ID} -d text='${env.MESSAGE_FAILURE}'"
                        // sh "curl -X POST -H 'Content-Type: application/json' -d '{\"text\": \"${env.MESSAGE_FAILURE}\"}' ${GOOGLE_CHAT_WEBHOOK}"
                        // sh "curl -X POST -H 'Content-Type: application/json' -d '{\"text\": \"${env.MESSAGE_FAILURE}\"}' '${GOOGLE_CHAT_WEBHOOK}'"
                        googlechatnotification url: 'GOOGLE_CHAT_WEBHOOK', message: "${env.MESSAGE_FAILURE}: ${env.JOB_NAME} - ${env.BUILD_NUMBER}\n last commit ```${env.GIT_LAST_COMMIT}```\n author *${env.GIT_LAST_AUTHOR}*\n Full details click on link: ${env.BUILD_URL}"

                    }
                    }
                }
}
