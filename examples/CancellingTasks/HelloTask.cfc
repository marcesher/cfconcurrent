component{

	result = {startTick = getTickCount(), startTS = now(), message = ""};

	function init(sleepTime=10, id = 1){
		structAppend( variables, arguments );
		return this;
	}

	function call(){
		writeLog(" #variables.id#: Starting call(). Wheeeeeee...");
		result.callStartTick = getTickCount();
		var q = new Query();
		q.setDatasource('nfpors3');
		q.setSql("select top 10 * from v_ActivityTreatmentDump");
		q.execute();
		result.message &= " Finally finished!";
		writeLog("later from id #id#!");
		result.endTick = getTickCount();
		return result;
	}
	
	function getResult(){return result;}

}