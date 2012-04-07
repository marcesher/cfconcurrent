component output="false" accessors="true"{

	property name="cfcDynamicProxy";

	supportsNativeProxy = structKeyExists( getFunctionList(), "createDynamicProxy" );
	callableInterfaces = ["java.util.concurrent.Callable"];
	runnableInterfaces = ["java.lang.Runnable"];
	variables.serverScopeName = "__cfconcurrentJavaLoader";
	timeUnit = createTimeUnit();

	public function init(){
		if( NOT supportsNativeProxy ){
			writeLog("Native createDynamicProxy not supported... falling back to JavaLoader. All Hail Galaxar! er... Mark Mandel!");
			structDelete( server, variables.serverScopeName );
			var proxyJarPath = getDirectoryFromPath( getCurrentTemplatePath() ) & "/javaloader/support/cfcdynamicproxy/lib/cfcdynamicproxy.jar";
			var paths = [proxyJarPath];
			server[variables.serverScopeName] = new javaloader.JavaLoader( loadPaths = paths, loadColdFusionClassPath = true );

			variables.CFCDynamicProxy = getJavaloader().create( "com.compoundtheory.coldfusion.cfc.CFCDynamicProxy" );
		}
		return this;
	}

	public function getJavaLoader(){
		return server[variables.serverScopeName];
	}

	public function getProcessorCount(){
		return createObject("java", "java.lang.Runtime").getRuntime().availableProcessors();
	}

	public function createTimeUnit(){
		return createObject( "java", "java.util.concurrent.TimeUnit" );
	}

	public function createQueue( maxQueueSize, queueClass="java.util.concurrent.LinkedBlockingQueue" ){
		return createObject("java", queueClass).init( maxQueueSize );
	}

	public function createThreadPoolExecutor( maxConcurrent, workQueue, rejectionPolicy="DiscardPolicy"){
		return createObject("java", "java.util.concurrent.ThreadPoolExecutor").init(
			maxConcurrent,
			maxConcurrent,
			0,
			timeUnit.SECONDS,
			workQueue,
			createRejectionPolicyByName( rejectionPolicy )
		);
	}

	public function createScheduledThreadPoolExecutor( maxConcurrent=1, rejectionPolicy="DiscardPolicy" ){
		return createObject("java", "java.util.concurrent.ScheduledThreadPoolExecutor").init(
			maxConcurrent,
			createRejectionPolicyByName( rejectionPolicy )
		);
	}

	public function createCompletionService( executor, completionQueue ){
		return createObject("java", "java.util.concurrent.ExecutorCompletionService").init( executor, completionQueue );
	}

	public function createRejectionPolicyByName( name ){
		return createObject("java", "java.util.concurrent.ThreadPoolExecutor$#name#").init();
	}

	public function createDiscardPolicy(){
		return createRejectionPolicyByName("DiscardPolicy");
	}

	public function createDiscardOldestPolicy(){
		return createRejectionPolicyByName("DiscardOldestPolicy");
	}

	public function createAbortPolicy(){
		return createRejectionPolicyByName("AbortPolicy");
	}

	public function createCallerRunsPolicy(){
		return createRejectionPolicyByName("CallerRunsPolicy");
	}

	public function getTimeUnitByName( unit="seconds" ){
		switch(unit){
			case "seconds":
				return timeUnit.SECONDS;
			case "milliseconds":
				return timeUnit.MILLISECONDS;
			case "nanoseconds":
				return timeUnit.NANOSECONDS;
			case "microseconds":
				return timeUnit.MICROSECONDS;
			case "minutes":
				return timeUnit.MINUTES;
			case "hours":
				return timeUnit.HOURS;
			case "days":
				return timeUnit.DAYS;
			default:
				throw("unknown unit #arguments.unit#. Valid values are 'seconds', 'nanoseconds', 'microseconds', 'milliseconds', 'minutes', 'hours', 'days'");
		}
	}

	public function createSubmittableProxy( object ){
		if( isCallable( object ) ){
			return createProxy( object, callableInterfaces );
		}
		if( isRunnable( object ) ){
			return createProxy( object, runnableInterfaces );
		}

		throw("Task must have either a call() or run() method", "TaskNotSubmittable");
	}

	public function createRunnableProxy( object ){
		ensureRunnableTask( object );
		return createProxy( object, runnableInterfaces );
	}

	public function createCallableProxy( object ){
		ensureCallableTask( object );
		return createProxy( object, callableInterfaces );
	}

	public function createProxy( object, interfaces ){
		if( supportsNativeProxy ){
			return createDynamicProxy( arguments.object, arguments.interfaces );
		} else {
			return cfcDynamicProxy.createInstance( arguments.object, arguments.interfaces );
		}
	}

	public function ensureRunnableTask( task ){
		if( NOT isRunnable( task ) ){
			throw("Task does not have a run() method", "TaskNotRunnable")
		}
	}

	public function ensureCallableTask( task ){
		if( NOT isCallable( task ) ){
			throw("Task does not have a call() method", "TaskNotCallable")
		}
	}

	public function isCallable( object ){
		return isObject( object ) AND structKeyExists( object, "call" );
	}

	public function isRunnable( object ){
		return isObject( object ) AND structKeyExists( object, "run" );
	}
}