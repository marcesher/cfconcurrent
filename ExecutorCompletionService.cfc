component extends="AbstractExecutorService" accessors="true" output="false"{

	property name="completionQueueProcessFrequency" type="numeric";
	property name="completionQueueProcessTask";
	property name="completionQueueProcessTaskProxy";

	//expose all the guts... power users need this stuff, and they shall have it
	property name="workQueue";
	property name="completionQueue";
	property name="workExecutor";
	property name="executorCompletionService";
	property name="completionQueueProcessService";

	variables.completionQueueProcessTask = "";
	variables.completionQueueProcessTaskFuture = "";
	variables.completionQueueProcessTaskID = "completionQueueProcessor";

	/**
	* @serviceName The unique application name for this Completion service
	  @maxConcurrent The maximum number of tasks which will be run at one time. A value of 0 will cause the maxConcurrent to be calculated as Number of CPUs + 1
	  @completionQueueProcessFrequency
	  @maxWorkQueueSize
	  @maxCompletionQueueSize
	*/
	public function init( serviceName, numeric maxConcurrent=0, numeric completionQueueProcessFrequency=30, numeric maxWorkQueueSize=10000, numeric maxCompletionQueueSize=100000, objectFactory="#createObject('component', 'ObjectFactory').init()#" ){

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
		variables.completionQueue = objectFactory.createQueue( maxCompletionQueueSize );
		variables.executorCompletionService = objectFactory.createCompletionService( workExecutor, completionQueue );
		setSubmissionTarget( executorCompletionService );

		//store the executor for sane destructability
		storeExecutor( "workExecutor", variables.workExecutor );

		variables.completionQueueProcessService = new ScheduledThreadPoolExecutor( serviceName, 1, objectFactory ).start();

		//in the event that a completion task has been set prior to start(), we'll schedule it now
		scheduleCompletionTask();

		return super.start();
	}

	/**
	* A Task CFC with a void run() method
	*/
	public function setCompletionQueueProcessTask( completionQueueProcessTask ){

		structAppend( variables, arguments );

		completionQueueProcessFuture = scheduleCompletionTask();
	}

	private function scheduleCompletionTask(){
		logMessage("Starting to schedule completion task");
		if( structKeyExists( variables, "completionQueueProcessService") AND NOT isSimpleValue(variables.completionQueueProcessTask) ){
			logMessage( "scheduling completion task at rate of #completionQueueProcessFrequency#" );

			completionQueueProcessTask.setExecutorCompletionService( getExecutorCompletionService() );
			return completionQueueProcessService.scheduleAtFixedRate( completionQueueProcessTaskID, completionQueueProcessTask, completionQueueProcessFrequency, completionQueueProcessFrequency, "seconds");
		}
	}

}