component extends="cfconcurrent.Application"{

	this.name = "cfconcurrent_executorCompletionService";

	function onApplicationStart(){
		writeLog("Starting #application.applicationName# Completion Service");
		//a maxConcurrent of 0 will cause the service to default to the number of Available Processors + 1
		application.executorCompletionService = createObject("component", "cfconcurrent.ExecutorCompletionService")
			.init( serviceName = "executorCompletionServiceExample",
					maxConcurrent = 0,
					completionQueueProcessFrequency = 2 );
		application.executorCompletionService.setLoggingEnabled( true );
		application.completionTask = createObject("component", "CompletionTask");
		application.completionTask.setLoggingEnabled( true );
		application.executorCompletionService.setCompletionQueueProcessTask( application.completionTask );

		application.executorCompletionService.start();
	}

	function onRequestStart(){
		if( structKeyExists(url, "stop") OR structKeyExists(url, "reinit") ){
			applicationStop();
		}

		if( structKeyExists(url, "reinit") ){
			location( "index.cfm", false );
		}
	}

	function onApplicationEnd(required struct applicationScope){
		if (structKeyExists(arguments.applicationScope, "executorCompletionService")) {
			writeLog("Stopping #application.applicationName# Completion Service");
			arguments.applicationScope.executorCompletionService.stop(timeout=5000);
		}
	}

}