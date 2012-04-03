component extends="cfconcurrent.Application"{

	this.name = "cfconcurrent_executorService";


	function onApplicationStart(){
		application.executorService = createObject("component", "cfconcurrent.ExecutorService")
			.init( appName = "executorServiceExample", maxConcurrent = 0, maxWorkQueueSize = 100000);
		application.executorService.setLoggingEnabled( true );
		application.executorService.start();
	}

	function onRequestStart(){
		if( structKeyExists(url, "reinit") ){
			ormReload();
			applicationStop();
			onApplicationStop();
		}
	}

	function onApplicationStop(){
		application.executorService.stop();
	}

}