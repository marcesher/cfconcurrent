component extends="cfconcurrent.Application"{

	this.name = "cfconcurrent_completionService";


	function onApplicationStart(){
		writeLog("Starting #application.applicationName# Completion Service");
		//setting maxConcurrent to 0 will cause cfconcurrent to base the maxConcurrent number on the available processors
		application.completionService = createObject("component", "cfconcurrent.CompletionService")
			.init( appName = "completionServiceExample",
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