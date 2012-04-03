component extends="cfconcurrent.AbstractCompletionTask"{

	publishCount = 0;

	function publish( results ){
		publishCount += arrayLen(results);
		writeLog("Publish: received #arrayLen(results)# tasks. Total: #publishCount#");

	}

}