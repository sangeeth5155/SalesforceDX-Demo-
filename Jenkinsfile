import groovy.json.JsonSlurperClassic
pipeline {
	environment 
	{
    def SFDC_USERNAME=''	
    def HUB_ORG=System.getenv("HUB_ORG_DHC")
    def SFDC_HOST=System.getenv("SFDC_HOST_DH")
    def JWT_KEY_CRED_ID=System.getenv("JWT_CRED_ID_DH")
	def rmgsplit=''
    def CONNECTED_APP_CONSUMER_KEY=System.getenv("CONNECTED_APP_CONSUMER_KEY_DH")
   def toolbelt =com.cloudbees.jenkins.plugins.customtools.CustomTool("toolbelt")
	
	}
	agent any
    stages {
	stage('checkout source') {
        steps
		{
       checkout scm 
	      }
	}
	stage('Authorize Scratch Org') {
		steps{
		withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')])
		{
		script
		{
           echo "started"
			//echo "\${toolbelt}"
	  
           rc = bat returnStatus: true,script: "\"${toolbelt}/sfdx\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername"
            if (rc != 0) { error 'hub org authorization failed' }
			
			rmsg = bat returnStdout: true, script: "\"${toolbelt}/sfdx\" force:org:create --definitionfile config/project-scratch-def.json --json --setdefaultusername"
         echo "results in rmg in values--------------------------->"+rmsg
		echo rmsg.getClass().getName()
		println rmsg.length()
		
		
			def rmsg1=rmsg.substring(rmsg.indexOf("{"))
			 
			def robj =new JsonSlurperClassic().parseText(rmsg1)
			print robj
			echo "status checking"			
            if (robj.status != 0) { error 'org creation failed: ' + robj.message }
			echo "assign values";
            SFDC_USERNAME=robj.result.username
			println SFDC_USERNAME
            robj = null 
		
        }
		}
		}
		}
		
	
	stage('Push To Test Org'){
	steps{
	withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
	script{
            rc = bat returnStatus: true, script: "\"${toolbelt}/sfdx\" force:source:push --targetusername ${SFDC_USERNAME}"
            if (rc != 0)
			{
                error 'push failed'
			}
            }
			}
            
        }
		}
		/* stage('Push Data into Scratch')
		{
		steps{
	withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
	script{
            rc = bat returnStatus: true, script: "\"${toolbelt}/sfdx\" force:data:tree:import -f data/UserDetail__c.json --targetusername ${SFDC_USERNAME}"
            if (rc != 0)
			{
                error 'push failed'
			}
            }
			}
            
        }
		
		}*/
		  stage('Run Apex Test') {
		  steps{
	withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
	script{
				
				//bat "rd ${RUN_ARTIFACT_DIR}|echo y|del ${RUN_ARTIFACT_DIR}/*.xml,.json,.txt"
				bat "if not exist ${RUN_ARTIFACT_DIR} md ${RUN_ARTIFACT_DIR}"   
				
				
				rc = bat returnStatus: true,script: "\"${toolbelt}/sfdx\" force:apex:test:run --testlevel RunLocalTests --outputdir ${RUN_ARTIFACT_DIR} --resultformat tap --targetusername ${SFDC_USERNAME}"
                if (rc != 0) {
                    error 'apex test run failed'
                }
				}
				}
				}
            }
      		
        stage('collect results') {
		steps{
	withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
	script{
				junit keepLongStdio: true, testResults: 'test/*-junit.xml'
				bat "zip -r C:/Nexus/sonatype-work/nexus/storage/SalesforceDx_Test_Results/test.zip ${RUN_ARTIFACT_DIR}"
        }
		}
		}
		}
		stage('Delete Scratch Org')
		{
		steps{
	withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
	script{
		rc = bat returnStatus: true,script: "\"${toolbelt}/sfdx\" force:org:delete -p --targetusername ${SFDC_USERNAME}"
                if (rc != 0) {
                    error 'apex test run failed'
                }
		}
		}
		}
		}
       
	   stage ('Covert to MDAPI')
		{
		steps{
	withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
	script{
		bat "if not exist ${MDAPI_FORMAT} md ${MDAPI_FORMAT}"
		rc = bat returnStatus: true,script: "\"${toolbelt}/sfdx\" force:source:convert -d ${MDAPI_FORMAT}"
		bat "git add ."
		bat "git commit -m 'changes' "
		bat "git push origin HEAD:master"		
		}
		}
		}
		}
		stage('Deployment Against Sandbox')
		{
		steps{
	withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
	script{
		 rc = bat returnStatus: true, script: "\"${toolbelt}/sfdx\" force:mdapi:deploy -c -d ${MDAPI_FORMAT} -u sangeeth.g@mstsolutions.com -l RunAllTestsInOrg"
		 
		}
		}
		}
		}
		/*stage('Actual Deployment')
		{
		// rc = bat returnStatus: true, script: "\"${toolbelt}/sfdx\" force:mdapi:deploy -d ${MDAPI_FORMAT} -u test-cfgk1svera0g@demo_company.net -l RunAllTestsInOrg"
		 
		}*/	
    }
	
post{
	
        success {
             mail (to: 'sangeetharajan.g@mstsolutions.com',
         subject: "Build Success '${env.JOB_NAME}' (${env.BUILD_NUMBER}) ",
         body: "Build Success ${env.BUILD_URL}.");
        }
		
        failure {
            mail (to: 'sangeetharajan.g@mstsolutions.com',
         subject: "Build Failure '${env.JOB_NAME}' (${env.BUILD_NUMBER}) is waiting for input",
         body: "Build Failure ${env.BUILD_URL}.");
        }
		}
