/*
Collects all completed futures and pushes them to a process() method. Implements the java.lang.Runnable interface
 */
component output="false" accessors="true"{

	property name="executorCompletionService";

	public function init( executorCompletionService ){
		structAppend( variables, arguments );
		return this;
	}
	
	public function process( array results ){
		writeLog("OVERRIDE ME!");
	}

	public function run(){
		var allResults = [];		
		var startTick = getTickCount();
		var thisTask = javacast( "null", 0 );
		try
		{
			thisTask = executorCompletionService.poll();
		} catch( any e )
		{
			writeLog("Error in Completion Task polling the queue : #e.getMessage()#; #e.getDetail()#");
		}
		
		while(  NOT isNull( thisTask ) ){

			try
		    {
		    	arrayAppend( allResults, thisTask.get() );
		    }
		    catch( any e )
		    {
		    	writeLog("Error in Completion Task polling the queue : #e.getMessage()#; #e.getDetail()#");
		    }

			thisTask = executorCompletionService.poll();
		}
		
		try
		{
			if( NOT arrayIsEmpty(allResults) ){
				process( allResults );
			} else {
				writeLog("Results were empty...");
			}
		}
		catch( Any e )
		{
			writeLog("Error in Completion Task process : #e.getMessage()#; #e.getDetail()#")
		}

	}

}
