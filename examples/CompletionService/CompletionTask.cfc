component extends="cfconcurrent.AbstractCompletionTask"{

	publishCount = 0;

	function publish( results ){
		publishCount += arrayLen(results);
		writeLog("Publish: received #arrayLen(results)# tasks. Total: #publishCount#");
		writeLog("Publish: first task ID: #results[1].id#; it slept for #results[1].sleepTime# ms. last task ID: #results[arrayLen(results)].id#; it slept for #results[arrayLen(results)].sleepTime# ms");
	}

}