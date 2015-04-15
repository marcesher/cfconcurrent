component extends="cfconcurrent.Application"{

	this.name = "cfconcurrent_ormInExecutor";

	//for ORM tests and examples
	this.ormEnabled = true;
	this.datasource = "cfartgallery";
	this.ormSettings = {flushAtRequestEnd = false, automanageSession = false, logsql = true};


	function onApplicationStart(){
		application.executorCompletionService = createObject("component", "cfconcurrent.ExecutorCompletionService").init("ormInExecutor", 0, 2);
		application.completionTask = createObject("component", "cfconcurrent.examples.ormInExecutor.model.CompletionTask");
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
			arguments.applicationScope.executorCompletionService.stop();
		}
	}

}