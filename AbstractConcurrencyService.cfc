component output="false" accessors="true"{

	property name="appName" type="string";
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
	property name="storageScope" type="struct" setter="false";
	
	variables.logName = "cfconcurrent";
	variables.loggingEnabled = false;
	variables.baseStorageScopeName = "__cfconcurrent";
	variables.objectFactory = new cfconcurrent.ObjectFactory();
	variables.timeUnit = objectFactory.createTimeUnit();
	variables.status = "stopped";
	
	
	/*WARNING: you may be tempted to call stop() either on init or on start. Do Not Do So.
		These services might use other services, and calling stop() would have the effect of undoing
		work that you *just* did -- any executors you create prior to calling start() on another
		service would cancel those executors.
		
		It is the responsibility of the user of this library to call stop() on services he/she starts
	*/
	
	public function init( String appName ){
		
		structAppend( variables, arguments );
		return this;
	}
	
	
	/* Lifecycle methods*/
	public function start(){
		//This will be overridden by implementers
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
	
	package function storeExecutor( string name, any executor ){
		var scope = getStorageScope();
		if( structKeyExists( scope, arguments.name ) ){
			logMessage( "Executor named #arguments.name# already existed. Shutting it down and replacing it" );
			scope[ arguments.name ].shutdownNow();
		}
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