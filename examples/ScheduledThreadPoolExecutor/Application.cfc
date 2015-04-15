component extends="cfconcurrent.Application"{

	this.name = "cfconcurrent_ScheduledThreadPoolExecutor";


	function onApplicationStart(){
		application.executorService = createObject("component", "cfconcurrent.ScheduledThreadPoolExecutor")
			.init( serviceName = "ScheduledThreadPoolExecutorExample", maxConcurrent = 0 );
		application.executorService.setLoggingEnabled( true );
		application.executorService.start();

		//now schedule a runnable task to run every few seconds
		application.task1 = createObject("component", "SimpleRunnableTask").init( "task1" );
		application.executorService.scheduleAtFixedRate("task1", application.task1, 0, 2, application.executorService.getObjectFactory().SECONDS);
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
		if (structKeyExists(arguments.applicationScope, "executorService")) {
			arguments.applicationScope.executorService.stop();
		}
	}

}