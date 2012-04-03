component extends="cfconcurrent.Application"{

	this.name = "cfconcurrent_ormInExecutor";

	//for ORM tests and examples
	this.ormEnabled = true;
	this.datasource = "cfartgallery";
	this.ormSettings = {flushAtRequestEnd = false, automanageSession = false, logsql = true};


	function onApplicationStart(){
		application.completionService = createObject("component", "cfconcurrent.CompletionService").init("ormInExecutor", 0, 2);
		application.completionTask = createObject("component", "cfconcurrent.examples.ormInExecutor.model.CompletionTask");
		application.completionService.setCompletionQueueProcessTask( application.completionTask );
		application.completionService.start();
	}

	function onRequestStart(){
		if( structKeyExists(url, "reinit") ){
			ormReload();
			applicationStop();
			onApplicationStop();

		}
	}

	function onApplicationStop(){
		application.completionService.stop();
	}

}