component extends="mxunit.framework.TestCase"{

	function setUp(){
		executorCompletionService = new cfconcurrent.ExecutorCompletionService("unittest");
		executorCompletionService.start();

 		javaCompletionService = executorCompletionService.getExecutorCompletionService();
		completionTask = new fixture.variablesCollectingTaskFixture( javaCompletionService );
	}

	function tearDown(){
		executorCompletionService.stop();
	}

	function completed_tasks_are_polled(){
		var task1 = new fixture.simpleCallableTask("task1");
		var task2 = new fixture.simpleCallableTask("task2");
		var factory = executorCompletionService.getObjectFactory();

		var proxy1 = factory.createSubmittableProxy(task1);
		var proxy2 = factory.createSubmittableProxy(task2);

		javaCompletionService.submit(proxy1);
		javaCompletionService.submit(proxy2);

		sleep(50);

		completionTask.run();

		debug(completionTask.getAllCollected());

		assertEquals( 2, arrayLen(completionTask.getAllCollected()) );
	}

	function last_error_is_captured(){
		var task1 = new fixture.ErrorThrowingTask("task1");
		var factory = executorCompletionService.getObjectFactory();
		var proxy1 = factory.createSubmittableProxy(task1);
		javaCompletionService.submit(proxy1);
		sleep(10);
		completionTask.run();
		debug(completionTask.getAllCollected());
		debug(completionTask.getLastError());
	}

}