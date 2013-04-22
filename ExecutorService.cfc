component extends="AbstractExecutorService" accessors="true" output="false"{

	//expose all the guts... power users need this stuff, and they shall have it
	property name="workQueue";
	property name="workExecutor";

	/**
	* @serviceName The unique application name for this Completion service
	  @maxConcurrent The maximum number of tasks which will be run at one time. A value of 0 will cause the maxConcurrent to be calculated as Number of CPUs + 1
	  @maxWorkQueueSize
	*/
	public function init( serviceName, numeric maxConcurrent=0, numeric maxWorkQueueSize=10000, objectFactory="#createObject('component', 'ObjectFactory').init()#" ){

		super.init( serviceName, objectFactory );
		structAppend( variables, arguments );
		if( maxConcurrent LTE 0 ){
			variables.maxConcurrent = getProcessorCount() + 1;
		}

		return this;
	}

	public function start(){

		variables.workQueue = objectFactory.createQueue( maxWorkQueueSize );

		//TODO: extract this policy and make it settable
		variables.workExecutor = objectFactory.createThreadPoolExecutor( maxConcurrent, workQueue, "DiscardPolicy" );
		setSubmissionTarget( workExecutor );

		//store the executor for sane destructability
		storeExecutor( "workExecutor", variables.workExecutor );

		return super.start();
	}


	/**
	* Executes the tasks, returning an array of Futures when all complete.
	* If the service is not running, tasks are ignored.
	* @tasks An array of task instances. A task CFC must expose a call() method that returns a result
	* @timeout Maximum time to wait. 0 indicates to wait until completion
	* @timeUnit TimeUnit of the timeout argument. Defaults to TimeUnit.SECONDS.
	*/
	public function invokeAll( array tasks, timeout=0, timeUnit="#objectFactory.SECONDS#" ){
		var results = [];
		var proxies = [];

		if( isStarted() ){

			for( var task in tasks ){
				arrayAppend( proxies, objectFactory.createSubmittableProxy( task ) );
			}
			if( timeout LTE 0 ){
				return getSubmissionTarget().invokeAll( proxies );
			} else {
				return getSubmissionTarget().invokeAll( proxies, timeout, timeUnit );
			}

		} else if( isPaused() ) {
			writeLog("Service paused... ignoring submission");
		} else if( isStopped() ){
			throw("Service is stopped... not accepting new tasks");
		}
	}

	/**
	* Executes the tasks, returning the result of one that has completed successfully, if any do. This result will be the returned value from the task's call() method
	* If the service is not running, tasks are ignored.
	* @tasks An array of task instances. A task CFC must expose a call() method that returns a result
	* @timeout Maximum time to wait. 0 indicates to wait until completion
	* @timeUnit TimeUnit of the timeout argument. Defaults to TimeUnit.SECONDS
	*/
	public function invokeAny( array tasks, timeout=0, timeUnit="#objectFactory.SECONDS#" ){
		var results = [];
		var proxies = [];

		if( isStarted() ){

			for( var task in tasks ){
				arrayAppend( proxies, objectFactory.createSubmittableProxy( task ) );
			}
			if( timeout LTE 0 ){
				return getSubmissionTarget().invokeAny( proxies );
			} else {
				return getSubmissionTarget().invokeAny( proxies, timeout, timeUnit );
			}

		} else if( isPaused() ) {
			writeLog("Service paused... ignoring submission");
		} else if( isStopped() ){
			throw("Service is stopped... not accepting new tasks");
		}
	}

	/**
	* Straight from the javadoc: Executes the given command at some time in the future. The command may execute in a new thread, in a pooled thread, or in the calling thread, at the discretion of the Executor implementation.
	* This is the equivalent of fire-and-forget usage of cfthread

	* @runnableTask A task instance that exposes a void run() method
	*/
	public function execute( runnableTask ){
		var proxy = objectFactory.createRunnableProxy( runnableTask );
		getSubmissionTarget().execute( proxy );
	}

}