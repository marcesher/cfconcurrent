component extends="mxunit.framework.TestCase"{

	function setUp(){
		completionService = new cfconcurrent.CompletionService("unittest");
		completionService.start();
		
 		javaCompletionService = completionService.getCompletionService();
		completionTask = new variablesCollectingTaskFixture( javaCompletionService );
	}
	
	function tearDown(){
		completionService.stop();
	}

	function completed_tasks_are_polled(){
		var task1 = new simpleCallableTask("task1");
		var task2 = new simpleCallableTask("task2");
		var factory = completionservice.getObjectFactory();
		
		var proxy1 = factory.createCallableProxy(task1);  
		var proxy2 = factory.createCallableProxy(task2); 
		
		javaCompletionService.submit(proxy1); 
		javaCompletionService.submit(proxy2); 
		
		sleep(10);
		
		completionTask.run();
		
		debug(completionTask.getAllCollected());
		 
		assertEquals( 2, arrayLen(completionTask.getAllCollected()) );
	}
}