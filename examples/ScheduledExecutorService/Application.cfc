component extends="cfconcurrent.Application"{

	this.name = "cfconcurrent_scheduledExecutorService";


	function onApplicationStart(){
		application.executorService = createObject("component", "cfconcurrent.ScheduledExecutorService")
			.init( appName = "scheduledExecutorServiceExample", maxConcurrent = 0 );
		application.executorService.setLoggingEnabled( true );
		application.executorService.start();

		//now schedule a runnable task to run every few seconds
		application.task1 = createObject("component", "SimpleRunnableTask").init( "task1" );
		application.executorService.scheduleAtFixedRate("task1", application.task1, 0, 2, "seconds");
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