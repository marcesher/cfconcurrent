component extends="cfconcurrent.AbstractCompletionTask"{

	publishCount = 0;

	function process( results ){
		publishCount += arrayLen(results);
		writeLog("Process: received #arrayLen(results)# tasks. Total: #publishCount#");

	}

}