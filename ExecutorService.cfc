component extends="AbstractExecutorService" accessors="true" output="false"{

	//expose all the guts... power users need this stuff, and they shall have it
	property name="workQueue";
	property name="workExecutor";

	/**
	* @appName The unique application name for this Completion service
	  @maxConcurrent The maximum number of tasks which will be run at one time. A value of 0 will cause the maxConcurrent to be calculated as Number of CPUs + 1
	  @maxWorkQueueSize
	*/
	public function init( appName, numeric maxConcurrent=0, numeric maxWorkQueueSize=10000, objectFactory="#createObject('component', 'ObjectFactory').init()#" ){

		super.init( appName, objectFactory );
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

}