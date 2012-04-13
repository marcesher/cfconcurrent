/*
Collects all completed futures and pushes them to a publish() method. Implements the java.lang.Runnable interface
 */
component output="false" accessors="true"{

	property name="executorCompletionService";

	public function init( executorCompletionService ){
		structAppend( variables, arguments );
		return this;
	}
	
	public function publish( array results ){
		writeLog("OVERRIDE ME!");
	}

	public function run(){
		var allResults = [];		
		var startTick = getTickCount();
		
		try
		{
			var thisTask = executorCompletionService.take();
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
				publish( allResults );
			} else {
				writeLog("Results were empty...");
			}
		}
		catch( Any e )
		{
			writeLog("Error in Completion Task publish : #e.getMessage()#; #e.getDetail()#")
		}

	}

}
