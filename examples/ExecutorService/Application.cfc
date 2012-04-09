component extends="cfconcurrent.Application"{

	this.name = "cfconcurrent_executorService";


	function onApplicationStart(){
		application.executorService = createObject("component", "cfconcurrent.ExecutorService")
			.init( appName = "executorServiceExample", maxConcurrent = 0, maxWorkQueueSize = 100000);
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