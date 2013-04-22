component extends="mxunit.framework.TestCase"{

	function setUp(){
		service = new cfconcurrent.ScheduledThreadPoolExecutor( serviceName="unittest" );
		service.setLoggingEnabled( true );
		objectFactory = service.getObjectFactory();
	}

	function tearDown(){
		service.stop();
	}

	function sanity(){}

	function init_without_maxConcurrent_defaults_to_cpu_count_plus_one(){
		var cpus = service.getProcessorCount();
		assertEquals( cpus + 1, service.getMaxConcurrent() );
	}

	function start_adds_executors_to_storage(){
		service.start();
		assertTrue( service.isStarted() );

		var storage = service.getThisStorageScope();
		debug(storage);
		assertEquals( 1, structCount(storage) );
	}

	function stop_clears_storage(){
		service.start();
		service.stop();
		assertEquals( 0, structCount(service.getThisStorageScope() ) );
		service.stop();
		assertEquals( 0, structCount(service.getThisStorageScope() ) );
	}

	function sheduleAtFixedRate_schedules_task(){
		service.start();
		var task1 = new fixture.SimpleRunnableTask("task1");
		var task2 = new fixture.SimpleRunnableTask("task2");
		var future1 = service.scheduleAtFixedRate("task1", task1, 0, 100, objectFactory.MILLISECONDS);
		var future2 = service.scheduleAtFixedRate("task2", task2, 1, 100, objectFactory.MILLISECONDS);

		sleep(500);
		var task1Results = task1.getResults();
		var task2Results = task2.getResults();
		assertTrue( task1Results.runCount GTE 5 and task1Results.runCount LTE 10 );
		assertTrue( task2Results.runCount GTE 5 and task2Results.runCount LTE 10 );

		sleep(200);
		var queue = service.getScheduledExecutor().getQueue();
		assertEquals(2, structCount(service.getStoredTasks()));

		var cancelled1 = service.cancelTask( "task1" );
		var cancelled2 = service.cancelTask( "task2" );

		assertTrue( cancelled1.future.isCancelled() );
		assertTrue( cancelled2.future.isCancelled() );

		debug(queue);
		debug(queue.toArray());
		assertEquals(0, arrayLen(queue.toArray()));
		assertEquals(0, structCount(service.getStoredTasks()));
	}
}