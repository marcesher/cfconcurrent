component output="false" accessors="true"{

	property name="serviceName" type="string";
	property name="status" type="string";
	property name="objectFactory";
	property name="maxConcurrent" type="numeric";
	property name="loggingEnabled" type="boolean";
	property name="logName" type="string";
	property name="timeUnit" hint="a java.util.concurrent.TimeUnit instance";
	property name="submissionTarget";

	/*
		storage scope is a server-scoped bucket into which we put "things that can shut down";
		we need this as a safeguard against developers who don't heed instructions to *ensure* that
		stop() is called onApplicationStop().

		Any executors we create will live in this scope, and on initialization, any previously created
		executors will be shutdown immediately and then removed from scope
	*/
	property name="thisStorageScope" type="struct" setter="false";

	variables.logName = "cfconcurrent";
	variables.loggingEnabled = false;
	variables.baseStorageScopeName = "__cfconcurrent";

	variables.status = "stopped";


	/*WARNING: you may be tempted to call stop() either on init or on start. Do Not Do So.
		These services might use other services, and calling stop() would have the effect of undoing
		work that you *just* did -- any executors you create prior to calling start() on another
		service would cancel those executors.

		It is the responsibility of the user of this library to call stop() on services he/she starts
	*/

	public function init( String serviceName, objectFactory="#createObject('component', 'ObjectFactory').init()#" ){

		structAppend( variables, arguments );
		variables.timeUnit = objectFactory.createTimeUnit();
		return this;
	}


	/* Lifecycle methods*/

	public function start(){
		//This will be overridden by implementers
		status = "started";
		return this;
	}

	public function stop( timeout=100, timeUnit="milliseconds" ){
		shutdownAllExecutors( timeout, timeUnit );
		status = "stopped";
		return this;
	}

	public function pause(){
		status = "paused";
		return this;
	}

	public function unPause(){
		if( isStopped() ){
			start();
		} else {
			status = "started";
		}
		return this;
	}

	public function isStarted(){
		return getStatus() eq "started";
	}

	public function isStopped(){
		return getStatus() eq "stopped";
	}

	public function isPaused(){
		return getStatus() eq "paused";
	}

	/* Execution methods */

	/**
	* Submits an object for execution. Returns a Future if Callable and a RunnableFuture if Runnable
	* If the service is not running, tasks are ignored
	* @task A task instance. Object must expose either a call() or run() method.
	*/
	public function submit( task ){

		if( isStarted() ){
			var proxy = objectFactory.createSubmittableProxy( task );
			return getSubmissionTarget().submit( proxy );

		} else if( isPaused() ) {
			writeLog("Service paused... ignoring submission");
		} else if( isStopped() ){
			throw("Service is stopped... not accepting new tasks");
		}
	}

	/**
	* Executes the tasks, returning an array of Futures when all complete.
	* If the service is not running, tasks are ignored.
	* @tasks An array of task instances. A task CFC must expose a call() method that returns a result
	* @timeout Maximum time to wait. 0 indicates to wait until completion
	* @timeUnit TimeUnit of the timeout argument, as a string. Defaults to "seconds".
	*/
	public function invokeAll( array tasks, timeout=0, timeUnit="seconds" ){
		var results = [];
		var proxies = [];

		if( isStarted() ){

			for( var task in tasks ){
				arrayAppend( proxies, objectFactory.createSubmittableProxy( task ) );
			}
			if( timeout LTE 0 ){
				return getSubmissionTarget().invokeAll( proxies );
			} else {
				return getSubmissionTarget().invokeAll( proxies, timeout, objectFactory.getTimeUnitByName( timeUnit ) );
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
	* @timeUnit TimeUnit of the timeout argument, as a string. Defaults to "seconds".
	*/
	public function invokeAny( array tasks, timeout=0, timeUnit="seconds" ){
		var results = [];
		var proxies = [];

		if( isStarted() ){

			for( var task in tasks ){
				arrayAppend( proxies, objectFactory.createSubmittableProxy( task ) );
			}
			if( timeout LTE 0 ){
				return getSubmissionTarget().invokeAny( proxies );
			} else {
				return getSubmissionTarget().invokeAny( proxies, timeout, objectFactory.getTimeUnitByName( timeUnit ) );
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

	/* Storage methods for shutdown management */

	/**
	* application["__cfoncurrent"]
	*/
	public function getBaseStorageScope(){
		if( NOT structKeyExists( application, variables.baseStorageScopeName ) ){
			application[variables.baseStorageScopeName] = {};
		}
		return application[variables.baseStorageScopeName];
	}

	/**
	* application["__cfconcurrent"][application.applicationname]
	*/
	public function getApplicationStorageScope(){
		var scope = getBaseStorageScope();
		if( NOT structKeyExists( scope, application.applicationname ) ){
			scope[application.applicationname] = {};
		}
		return scope;
	}

	/**
	* application["__cfconcurrent"][application.applicationname][ getserviceName() ]

		serviceName does NOT have to be application.applicationname... it should be a name that *uniquely* identifies
		This concurrency service in the application.

		If the application has multiple concurrency services, they must be uniquely named
	*/
	public function getThisStorageScope(){
		var scope = getApplicationStorageScope();
		if( NOT structKeyExists( scope, serviceName) ){
			scope[serviceName] = {};
		}
		return scope[serviceName];
	}

	public function logMessage( String text, String file="#logName#" ){
		if( getLoggingEnabled() ){
			writeLog( text=arguments.text, file=arguments.file );
		}
		return this;
	}

	public function getProcessorCount(){
		return objectFactory.getProcessorCount();
	}

	package function storeExecutor( string name, any executor ){
		var scope = getThisStorageScope();
		if( structKeyExists( scope, arguments.name ) ){
			logMessage( "Executor named #arguments.name# already existed. Shutting it down and replacing it" );
			scope[ arguments.name ].shutdownNow();
		}
		scope[ arguments.name ] = arguments.executor;
		return this;
	}

	package function shutdownAllExecutors( timeout=100, timeUnit="milliseconds" ){
		if( NOT structIsEmpty( getThisStorageScope() ) ){
			var scope = getThisStorageScope();
			for( var executor in scope ){
				writeLog("Waiting #timeout# #timeUnit# for tasks to complete and then shutting down executor named #executor#");
				scope[executor].awaitTermination( timeout, objectFactory.getTimeUnitByName( timeUnit ) );
				scope[executor].shutdownNow();
			}
			structClear( scope );
		}

		return this;
	}
}