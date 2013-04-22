component extends="mxunit.framework.TestCase"{

	function setUp(){
		service = new cfconcurrent.ExecutorService(serviceName="unittest");
		objectFactory = service.getObjectFactory();
		service.setLoggingEnabled( true );
		service.start();
	}

	function tearDown(){
		service.stop(1);
	}

	function init_without_maxConcurrent_defaults_to_cpu_count_plus_one(){
		var cpus = service.getProcessorCount();
		assertEquals( cpus + 1, service.getMaxConcurrent() );
	}

	function submit_callable_returns_future(){
		var task = new fixture.SimpleCallableTask(1);
		var future = service.submit( task );
		var result = future.get();
		debug( result );
		debug( future );
		assertTrue( structIsEmpty( result.error ) );
		assertEquals( 1, result.id );
		assertTrue( future.isDone() );
	}

	function submit_runnable_returns_runnable_future(){
		var task = new fixture.SimpleRunnableTask(1);
		var future = service.submit( task );
		var result = future.get();
		assertTrue( isNull(result), "RunnableFutures return null upon successful completion" );
		assertTrue( future.isDone() );
	}

	function invokeAll_returns_array_of_futures_for_array_of_tasks(){
		var tasks = [];
		for( var i = 1; i LTE 10; i++ ){
			arrayAppend( tasks, new fixture.SimpleCallableTask(i) );
		}

		var results = service.invokeAll( tasks );
		writeLog("results!");
		assertTrue( isArray(results) );
		for( var i = 1; i LTE 10; i++ ){
			var future = results[i];
			assertTrue( future.isDone() );
			var result = future.get();
			assertEquals( i, result.id );
		}
	}

	function invokeAll_honors_timeout(){
		var tasks = [];
		//create tasks that will sleep for 50 milliseconds
		for( var i = 1; i LTE 10; i++ ){
			arrayAppend( tasks, new fixture.SimpleCallableTask(i, 50) );
		}

		//invokeAll with a 20-ms timeout
		var results = service.invokeAll( tasks, 20, objectFactory.MILLISECONDS );

		for( future in results ){
			if( NOT future.isCancelled() ){
				fail("Task should have been cancelled b/c it did not complete by the timeout");
			}
		}
	}

	function invokeAny_returns_single_result(){
		var tasks = [];
		for( var i = 1; i LTE 10; i++ ){
			arrayAppend( tasks, new fixture.SimpleCallableTask(i) );
		}

		var result = service.invokeAny( tasks );
		assertTrue( result.id GTE 1 and result.id LTE 10 ); //the order in which tasks are run is indeterminate
	}

	/**
	* @mxunit:expectedException java.util.concurrent.TimeoutException
	*/
	function invokeAny_honors_timeout(){
		var tasks = [];
		//create tasks that will sleep for 50 milliseconds
		for( var i = 1; i LTE 10; i++ ){
			arrayAppend( tasks, new fixture.SimpleCallableTask(i, 50) );
		}

		//invokeAny with a 20-ms timeout
		var results = service.invokeAny( tasks, 20, objectFactory.MILLISECONDS );

	}

	function execute_executes_task(){
		var task = new fixture.SimpleRunnableTask(1);
		//guard
		assertEquals( 0, task.getResults().runCount );

		service.execute( task );
		sleep(2);
		debug(task.getResults());
		assertEquals( 1, task.getResults().runCount );
	}

}