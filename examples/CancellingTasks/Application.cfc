component extends="cfconcurrent.Application"{

	this.name = "cfconcurrent_executorService_cancellingTasks";

	function onApplicationStart(){
		//a maxConcurrent of 0 will cause the service to default to the number of Available Processors + 1
		application.executorService = createObject("component", "cfconcurrent.ExecutorService")
			.init( serviceName = "cancelExample", maxConcurrent = 0, maxWorkQueueSize = 100000);
		application.executorService.setLoggingEnabled( true );
		application.executorService.start();
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
		application.executorService.stop();
	}

}