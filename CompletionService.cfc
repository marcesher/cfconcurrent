component extends="ExecutorService" accessors="true" output="false"{

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
		structAppend( variables, arguments );
		return super.init( appName, maxConcurrent, maxWorkQueueSize );
	}
	
	public function start(){
		super.start();
		variables.completionQueue = objectFactory.createQueue( maxCompletionQueueSize );
		variables.completionService = objectFactory.createCompletionService( workExecutor, completionQueue );
		setSubmissionTarget( completionService );
		variables.completionQueueExecutor = objectFactory.createScheduledThreadPoolExecutor( 1 );
		
		//in the event that a completion task has been set prior to start(), we'll schedule it now
		scheduleCompletionTask();
		
		//store the executor for sane destructability
		storeExecutor( "completionQueueExecutor", variables.completionQueueExecutor );
		
		return this;
	}
	
	/**
	* A Task CFC with a void run() method
	*/
	public function setCompletionQueueProcessTask( completionQueueProcessTask ){
		objectFactory.ensureRunnableTask( arguments.completionQueueProcessTask );
		
		if( NOT isSimpleValue(variables.completionQueueProcessTaskProxy) ){
			completionQueueExecutor.remove( variables.completionQueueProcessTaskProxy );
		}
		
		structAppend( variables, arguments );
		variables.completionQueueProcessTaskProxy = objectFactory.createRunnableProxy( completionQueueProcessTask );
		
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