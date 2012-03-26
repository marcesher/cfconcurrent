component output="false" accessors="true"{

	property name="appName" type="string";
	property name="status" type="string";
	property name="proxyFactory";
	property name="maxConcurrent" type="numeric";
	property name="loggingEnabled" type="boolean";
	property name="logName" type="string";
	property name="timeUnit" hint="a java.util.concurrent.TimeUnit instance";
	
	/*
		storage scope is a server-scoped bucket into which we put "things that can shut down";
		we need this as a safeguard against developers who don't heed instructions to *ensure* that
		stop() is called onApplicationStop().
		
		Any executors we create will live in this scope, and on initialization, any previously created 
		executors will be shutdown immediately and then removed from scope
	*/
	property name="storageScope" type="struct" setter="false";
	
	variables.logName = "cfconcurrent";
	variables.loggingEnabled = false;
	variables.baseStorageScopeName = "__cfconcurrent";
	variables.timeUnit = createObject( "java", "java.util.concurrent.TimeUnit" );
	variables.status = "stopped";
	
	public function init( String appName ){
		
		structAppend( variables, arguments );
		shutdownAllExecutors();
		
		variables.proxyFactory = new cfconcurrent.ProxyFactory();
		
		return this;
	}
	
	
	/* Lifecycle methods*/
	public function start(){
		//doesn't do much, does it? This will be overridden by implementers
		status = "started";
		return this;
	}
	
	public function stop(){
		shutdownAllExecutors();
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
	
	public function getStorageScope(){
		if( NOT structKeyExists( server, variables.baseStorageScopeName ) ){
			server[variables.baseStorageScopeName] = {};
		}
		if( NOT structKeyExists( server[variables.baseStorageScopeName], appName) ){
			server[variables.baseStorageScopeName][appName] = {};
		}
		return server[variables.baseStorageScopeName][appName];
	}
	
	public function logMessage( String text, String file="#logName#" ){
		if( getLoggingEnabled() ){
			writeLog( text=arguments.text, file=arguments.file );
		}
		return this;
	}
	
	public function getProcessorCount(){
		return createObject("java", "java.lang.Runtime").getRuntime().availableProcessors();
	}
	
	public function ensureRunnableTask( task ){
		if( NOT isObject(task) OR NOT structKeyExists( task, "run" ) ){
			throw("Task does not have a run() method", "TaskNotRunnable")
		}
	}
	
	public function ensureCallableTask( task ){
		if( NOT isObject(task) OR NOT structKeyExists( task, "call" ) ){
			throw("Task does not have a call() method", "TaskNotCallable")
		}
	}
	
	package function storeExecutor( string name, any executor ){
		var scope = getStorageScope();
		scope[ arguments.name ] = arguments.executor;
		return this;
	}
	
	package function shutdownAllExecutors(){
		if( NOT structIsEmpty( getStorageScope() ) ){
			var scope = getStorageScope();
			for( var executor in scope ){
				writeLog("Shutting down executor named #executor#");
				scope[executor].shutdownNow();
			}
			structClear( scope );
		}
		
		return this;
	}
}