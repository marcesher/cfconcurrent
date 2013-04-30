/*
Collects all completed futures and pushes them to a process() method. Implements the java.lang.Runnable interface
 */
component output="false" accessors="true"{

	property name="executorCompletionService";
	property name="loggingEnabled" type="boolean";
	property name="lastError";

	variables.loggingEnabled = false;

	public function init( executorCompletionService ){
		structAppend( variables, arguments );
		return this;
	}

	public function process( array results ){
		writeLog("OVERRIDE ME!");
	}



	public function run(){
		var allResults = [];
		var thisTask = javacast( "null", 0 );
		try
		{
			thisTask = executorCompletionService.poll();
		} catch( any e )
		{
			logError(e, "Error in Completion Task polling the queue");
		}

		while(  NOT isNull( thisTask ) ){

			try
		    {
		    	var futureResult = thisTask.get();
		    	arrayAppend( allResults, futureResult );
		    }
		    catch( any e )
		    {
		    	logError(e, "Error in Completion Task polling the queue");
		    	arrayAppend( allResults, e );
		    }

			thisTask = executorCompletionService.poll();
		}

		try
		{
			if( NOT arrayIsEmpty(allResults) ){
				process( allResults );
			} else if( getLoggingEnabled() ) {
				writeLog("Results were empty...");
			}
		}
		catch( Any e )
		{
			logError(e, "Error in Completion Task process");
		}

	}

	function logError( error, message ){
		writeLog("#message# : #error.message#; #error.detail#");
		lastError = error;
	}

}
