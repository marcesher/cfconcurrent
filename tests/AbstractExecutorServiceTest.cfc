component extends="mxunit.framework.TestCase"{


	function setUp(){
		service = new cfconcurrent.AbstractExecutorService("unittest");
	}

	function tearDown(){
		service.stop();
	}

	function itsAlive(){
		service.setLoggingEnabled(true);
		service.logMessage("RIIIIISE");
	}

	function service_is_stopped_when_initialized(){
		assertTrue( service.isStopped() );
	}

	function multiple_stops_are_safe(){
		service.start();

		service.stop();
		service.stop();
		service.stop();
		assertTrue( service.isStopped() );
	}

	function service_is_started_when_started(){
		service.start();
		assertTrue( service.isStarted() );
	}

	function service_is_paused_when_paused(){
		service.pause();
		assertTrue( service.isPaused() );
	}

	function getStorageScope_returns_struct(){
		var scope = service.getThisStorageScope();
		assertTrue( isStruct(scope) );
		debug(scope);
	}

	function getProcessorCount_returns_positive_number(){
		var count = service.getProcessorCount();
		debug(count);
		assertTrue( count GTE 8 );//all my machines have at least 8 cores
	}
}