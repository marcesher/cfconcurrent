component extends="cfconcurrent.AbstractCompletionTask"{

	publishCount = 0;

	function process( results ){
		publishCount += arrayLen(results);
		writeLog("Process: received #arrayLen(results)# tasks. Total: #publishCount#");
		writeLog("Process: first task ID: #results[1].id#; it slept for #results[1].sleepTime# ms. last task ID: #results[arrayLen(results)].id#; it slept for #results[arrayLen(results)].sleepTime# ms");
	}

}