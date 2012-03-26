component extends="mxunit.framework.TestCase"{

	function setUp(){
		service = new cfconcurrent.CompletionService(appName="unittest", completionQueueProcessFrequency=1);
		service.setLoggingEnabled( true );
		completionTask = new VariablesCollectingTaskFixture(); 
		service.setCompletionQueueProcessTask( completionTask );
	}
	
	function tearDown(){
		service.stop();
	}

	function init_without_maxConcurrent_defaults_to_cpu_count_plus_one(){
		var cpus = service.getProcessorCount();
		assertEquals( cpus + 1, service.getMaxConcurrent() );
	}
	
	function start_adds_executors_to_storage(){
		service.start();
		assertTrue( service.isStarted() );
		
		var storage = service.getStorageScope();
		debug(storage);
		assertEquals( 2, structCount(storage) );
	}
	
	function stop_clears_storage(){
		service.start();
		service.stop();
		assertEquals( 0, structCount(service.getStorageScope() ) );
		service.stop();
		assertEquals( 0, structCount(service.getStorageScope() ) );
	}
	
	function completionService_publishes_finished_tasks(){
		service.start();
		var task1 = new SimpleCallableTask("task1");
		var task2 = new SimpleCallableTask("task2");
		var future1 = service.submitCallable(task1);
		var future2 = service.submitCallable(task2);
		
		//we know the unit test is set to publish every second
		sleep(1100);
		
		debug(service.getWorkQueue().size());
		debug(service.getCompletionQueue());
		debug(service.getCompletionQueue().size());
		
		debug(future1);
		debug(future1.isDone());
		debug(future1.get());
		
		assertEquals( 2, arrayLen(completionTask.getAllCollected() ) );
	}
}