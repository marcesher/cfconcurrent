component extends="cfconcurrent.Application"{

	this.name = "cfconcurrent_completionService";


	function onApplicationStart(){
		writeLog("Starting #application.applicationName# Completion Service");
		//a maxConcurrent of 0 will cause the service to default to the number of Available Processors + 1
		application.completionService = createObject("component", "cfconcurrent.CompletionService")
			.init( serviceName = "completionServiceExample",
					maxConcurrent = 0,
					completionQueueProcessFrequency = 2 );
		application.completionService.setLoggingEnabled( true );
		application.completionTask = createObject("component", "CompletionTask");
		application.completionService.setCompletionQueueProcessTask( application.completionTask );

		application.completionService.start();
	}

	function onRequestStart(){
		if( structKeyExists(url, "stop") OR structKeyExists(url, "reinit") ){
			applicationStop();
			onApplicationStop();
		}

		if( structKeyExists(url, "reinit") ){
			location( "index.cfm", false );
		}
	}

	function onApplicationStop(){
		writeLog("Stopping #application.applicationName# Completion Service");
		application.completionService.stop();
	}

}