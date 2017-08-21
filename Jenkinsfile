import groovy.json.JsonSlurperClassic
node {
    def SFDC_USERNAME
	def DEBUG_ISU=env.SFDX_DEBUG
    def HUB_ORG=env.HUB_ORG_DHC
    def SFDC_HOST=env.SFDC_HOST_DH
    def JWT_KEY_CRED_ID=env.JWT_CRED_ID_DH
	def rmgsplit
	

    def CONNECTED_APP_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH
    def toolbelt = tool 'toolbelt'
            println SFDC_HOST
            println JWT_KEY_CRED_ID
            println CONNECTED_APP_CONSUMER_KEY
            println HUB_ORG
			println toolbelt


    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
	
        stage('Authorize Scratch Org') {

           echo "started"
		   //echo debug_isu;
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
		
	stage('Push To Test Org') {
            rc = bat returnStatus: true, script: "\"${toolbelt}/sfdx\" force:source:push --targetusername ${SFDC_USERNAME}"
            if (rc != 0) {
                error 'push failed'
            }
            
        }
		  stage('Run Apex Test') {
				
				
				bat "if not exist ${RUN_ARTIFACT_DIR} md ${RUN_ARTIFACT_DIR}"   
				
				
				rc = bat returnStatus: true,script: "\"${toolbelt}/sfdx\" force:apex:test:run --testlevel RunLocalTests --outputdir ${RUN_ARTIFACT_DIR} --resultformat tap --targetusername ${SFDC_USERNAME}"
                if (rc != 0) {
                    error 'apex test run failed'
                }
				
            }
        		
        stage('collect results') {
            junit keepLongStdio: true, testResults: 'test/*-junit.xml'
		
			bat "zip -r C:/Program Files/nexus/sonatype-work/nexus/storage/SalesforceDx_Test_Results/test.zip ${RUN_ARTIFACT_DIR}"
        }
       
	   stage ('Covert to MDAPI')
		{
		bat "if not exist ${MDAPI_FORMAT} md ${MDAPI_FORMAT}"
		rc = bat returnStatus: true,script: "\"${toolbelt}/sfdx\" force:source:convert -d ${MDAPI_FORMAT}"
		bat "git add ${MDAPI_FORMAT}"
		bat "git commit -m 'changes' "
		bat "git push origin HEAD:master"		
		}
		stage('Deployment Against Sandbox')
		{
		 rc = bat returnStatus: true, script: "\"${toolbelt}/sfdx\" force:mdapi:deploy -c -d ${MDAPI_FORMAT} -u test-vdjfamysdj1u@demo_company.net -l RunAllTestsInOrg"
		 
		}
		stage('Actual Deployment')
		{
		 rc = bat returnStatus: true, script: "\"${toolbelt}/sfdx\" force:mdapi:deploy -d ${MDAPI_FORMAT} -u test-vdjfamysdj1u@demo_company.net -l RunAllTestsInOrg"
		 
		}
	    node{
	  post {
    failure {
        mail to: 'sangeetharajan.g@mstsolutions.com',
             subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Something is wrong with ${env.BUILD_URL}"
    }
}
	    }
    }
}
