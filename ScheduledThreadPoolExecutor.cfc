/**
* http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/ScheduledThreadPoolExecutor.html
*/
component extends="ExecutorService" accessors="true" output="false"{

	property name="scheduledExecutor";
	property name="storedTasks" type="struct";

	public function init( String serviceName, maxConcurrent=0, objectFactory="#createObject('component', 'ObjectFactory').init()#" ){

		super.init( serviceName, maxConcurrent, -1, objectFactory );

		variables.storedTasks = {};
		return this;
	}

	public function start(){
		variables.scheduledExecutor = variables.objectFactory.createScheduledThreadPoolExecutor( maxConcurrent );

		//store the executor for sane destructability
		storeExecutor( "scheduledExecutor", variables.scheduledExecutor );
		status = "started";
		return this;
	}

	public function scheduleAtFixedRate( id, task, initialDelay, period, timeUnit="#objectFactory.SECONDS#" ){
		cancelTask( id );
		var future = variables.scheduledExecutor.scheduleAtFixedRate(
			variables.objectFactory.createRunnableProxy( task ),
			initialDelay,
			period,
			timeUnit
		);
		storeTask( id, task, future );
		return future;
	}

	public function scheduleWithFixedDelay( id, task, initialDelay, delay, timeUnit="#objectFactory.SECONDS#" ){
		cancelTask( id );
		var future = variables.scheduledExecutor.scheduleWithFixedDelay(
			variables.objectFactory.createRunnableProxy( task ),
			initialDelay,
			delay,
			timeUnit
		);
		storeTask( id, task, future );
		return future;
	}

	package function storeTask( id, task, future ){
		variables.storedTasks[ id ] = { task = task, future = future };
		return this;
	}

	/**
	* Returns a struct with keys 'task' and 'future'. The 'task' is the original object submitted to the executor.
		The 'future' is the <ScheduledFuture> object returned when submitting the task
	*/
	public function cancelTask( id ){
		if( structKeyExists( variables.storedTasks, id ) ){
			var task = variables.storedTasks[ id ];
			var future = task.future;
			future.cancel( true );
			variables.scheduledExecutor.purge();
			structDelete( variables.storedTasks, id );
			return task;
		}
	}

}