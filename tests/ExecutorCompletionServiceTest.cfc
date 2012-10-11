component extends="mxunit.framework.TestCase"{

	function setUp(){
		service = new cfconcurrent.ExecutorCompletionService(serviceName="unittest", completionQueueProcessFrequency=1);
		service.setLoggingEnabled( true );
		completionTask = new fixture.VariablesCollectingTaskFixture();
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

		var storage = service.getThisStorageScope();
		debug(storage);
		assertEquals( 2, structCount(storage) );
	}

	function stop_clears_storage(){
		service.start();
		service.stop();
		assertEquals( 0, structCount(service.getThisStorageScope() ) );
		service.stop();
		assertEquals( 0, structCount(service.getThisStorageScope() ) );
	}

	function stop_clears_internal_scheduler_storage(){
		service.start();
		var scheduler = service.getcompletionQueueProcessService();

		assertTrue( scheduler.isStarted() );
		assertNotEquals( 0, structCount(scheduler.getThisStorageScope() ) );

		service.stop();

		assertTrue( scheduler.isStopped() );
		assertEquals( 0, structCount(scheduler.getThisStorageScope() ) );


	}

	function executorCompletionService_publishes_finished_tasks(){
		service.start();
		var task1 = new fixture.SimpleCallableTask("task1");
		var task2 = new fixture.SimpleCallableTask("task2");
		var future1 = service.submit(task1);
		var future2 = service.submit(task2);

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

	function entitySave_works_on_entity_passed_into_task_in_executor(){
		ormReload();
		entityLoadByPk("Artist", 1);
		service.start();

		var task1 = new fixture.SimpleCallableORMTask(1);
		var future1 = service.submit(task1);
		sleep(1100);

		var result = future1.get();
		debug( result );

		assertEquals( result.entity.getThePassword(), result.password );
		assertTrue( result.saved );
		assertTrue( structIsEmpty(result.error) );
	}

	function createObject_works_in_task_in_executor(){
		service.start();
		var task1 = new fixture.ObjectCreatingCallableTask(1);
		var future1 = service.submit(task1);
		sleep(1100);

		var result = future1.get();
		debug(result);

		assertTrue( NOT isSimpleValue(result.anObject) );
	}
}