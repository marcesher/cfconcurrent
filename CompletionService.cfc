component output="false" extends="AbstractConcurrencyService" accessors="true"{

	property name="completionQueueProcessFrequency" type="numeric";
	property name="completionQueueProcessTask";
	property name="completionQueueProcessTaskProxy";
	
	//expose all the guts... power users need this stuff, and they shall have it
	property name="workQueue";
	property name="completionQueue";
	property name="workExecutor";
	property name="completionService";
	property name="completionQueueExecutor";
	
	variables.completionQueueProcessTask = "";
	variables.completionQueueProcessTaskProxy = "";

	/**
	* @appName The unique application name for this Completion service
	  @maxConcurrent The maximum number of tasks which will be run at one time. A value of 0 will cause the maxConcurrent to be calculated as Number of CPUs + 1
	  @completionQueueProcessFrequency
	  @maxWorkQueueSize
	  @maxCompletionQueueSize
	*/
	public function init( appName, numeric maxConcurrent=0, numeric completionQueueProcessFrequency=30, numeric maxWorkQueueSize=10000, numeric maxCompletionQueueSize=100000 ){
		
		super.init( appName );
		structAppend( variables, arguments );
		if( maxConcurrent LTE 0 ){
			variables.maxConcurrent = getProcessorCount() + 1;
		}
		
		return this;
	}
	
	public function start(){
		
		variables.workQueue = createObject("java", "java.util.concurrent.LinkedBlockingQueue").init( maxWorkQueueSize );
		variables.completionQueue = createObject("java", "java.util.concurrent.LinkedBlockingQueue").init( maxCompletionQueueSize );
		
		//TODO: extract this policy and make it settable
		var discardPolicy = createObject("java", "java.util.concurrent.ThreadPoolExecutor$DiscardPolicy").init();
		variables.workExecutor = createObject("java", "java.util.concurrent.ThreadPoolExecutor").init( 
			maxConcurrent, 
			maxConcurrent, 
			0, 
			timeUnit.SECONDS, 
			workQueue, 
			discardPolicy
		);

		variables.completionService = createObject("java", "java.util.concurrent.ExecutorCompletionService").init( workExecutor, completionQueue );
		variables.completionQueueExecutor = createObject("java", "java.util.concurrent.ScheduledThreadPoolExecutor").init( 1 );
		
		//in the event that a completion task has been set prior to start(), we'll schedule it now
		scheduleCompletionTask();
		
		//store the executors for sane destructability
		storeExecutor( "workExecutor", variables.workExecutor );
		storeExecutor( "completionQueueExecutor", variables.completionQueueExecutor );
		
		return super.start();
	}
	
	public function submitCallable( task ){
		if( isStarted() ){
			ensureCallableTask( task );
			var proxy = proxyFactory.createCallableProxy( task );
			var future = getCompletionService().submit( proxy );
			return future;
			
		} else if( isPaused() ) {
			writeLog("Service paused... ignoring submission");
		} else if( isStopped() ){
			throw("Completion Service is stopped... not accepting new tasks");
		}
	}
	
	/**
	* A Task CFC with a void run() method
	*/
	public function setCompletionQueueProcessTask( completionQueueProcessTask ){
		ensureRunnableTask( arguments.completionQueueProcessTask );
		
		if( NOT isSimpleValue(variables.completionQueueProcessTaskProxy) ){
			completionQueueExecutor.remove( variables.completionQueueProcessTaskProxy );
		}
		
		structAppend( variables, arguments );
		variables.completionQueueProcessTaskProxy = proxyFactory.createRunnableProxy( completionQueueProcessTask );
		
		scheduleCompletionTask();
		
		return variables.completionQueueProcessTaskProxy;
	}
	
	private function scheduleCompletionTask(){
		logMessage("Starting to schedule completion task");
		if( structKeyExists( variables, "completionQueueExecutor") AND NOT isSimpleValue(variables.completionQueueProcessTaskProxy) ){
			logMessage( "scheduling completion task at rate of #completionQueueProcessFrequency#" );
			
			completionQueueProcessTask.setCompletionService( getCompletionService() );
			variables.completionQueueExecutor.scheduleAtFixedRate( completionQueueProcessTaskProxy, completionQueueProcessFrequency, completionQueueProcessFrequency, timeUnit.SECONDS );
		}
	}

} 