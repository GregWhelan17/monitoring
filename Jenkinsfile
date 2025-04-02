pipeline {
    // agent { label 'cm-linux' }
 
    stages {
        stage("Clone and checkout") {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: scm.branches,
                    extensions: scm.extensions, 
                    userRemoteConfigs: [[
                        credentialsId: scm.userRemoteConfigs[0].credentialsId,
                        name: 'origin', 
                        refspec: '+refs/heads/*:refs/remotes/origin/*', 
                        url: scm.userRemoteConfigs[0].url
                    ]],
                    doGenerateSubmoduleConfigurations: false
                ])
            }
        }
        stage('Authentication') {
            steps {
                withCredentials([usernamePassword(credentialsId: "service_acc_username_and_password", passwordVariable: 'password', usernameVariable: 'username')]) {
                    script {
                        kubectl_command = sh (
                            script: "curl -k -u ${username}:${password} -X GET https://oidc.${IKP_SERVER}.cloud.uk.hsbc/apitoken/token/user | jq -r '.token.\"kubectl Command\"'",
                            returnStdout: true
                        ).trim().replaceAll('\\$TMP_CERT','TMP_CERT').replaceAll(/export TMP_CERT=\$\(mktemp\) && /,'')
                        
                        output = sh (
                            script: kubectl_command,
                            returnStdout: true
                            ).trim()
                        println "Output after the command is run : $output"
                    }
                }
            }
        }
        stage('Monitor') {
            steps {
                withCredentials([usernamePassword(credentialsId: "turboAPI", passwordVariable: 'password', usernameVariable: 'username')]) {
                    script {
                        println "Kubectl command in separate stage:"
                        sh """kubectl config set-context --current --namespace=turbonomic"""
                        sh """chmod a+x *.sh"""
                        // result= sh (
                        //     script: "./monitor.sh ${username} ${password} ${non-critical-pods} | sed 's/\$/<BR>/' | sed 's/ /\\&nbsp;/g'",
                        //     returnStdout: true
                        // )
                        result= sh (
                            script: "./monitor.sh ${username} ${password} ${noncriticalpods}",
                            returnStdout: true
                        )
                        println "monitor result : $result"
                    }
                }
            }
        }
        stage('Notify') {
            steps {
                script {

                    html_body="""
                    
                    <!doctype html>
                    <html lang="en">
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                        <title>Turbonomic Status Email</title>
                        <style>
                        body { font-family: 'verdana', monospace; font-size: 12;}
                    </head>
                    <body>
                    <div>
                        <img src="./images/Turbo.png" alt="Turbonomic logo" />
                        $result
                    </body>

                    """

                    emailext body:  html_body, 
                                     mimeType: "text/html",
                                     subject: "Turbonomic Status",
                                     to: "$emails"

                }
            }
        }
    }
}
