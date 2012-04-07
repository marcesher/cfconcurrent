component{

	results = { created = now(), createTS = getTickCount(), error={} };

	function init( id, sleepTime=0 ){
		structAppend( results, arguments );
		return this;
	}

	function call(){
		try{
			writeLog("Inside call!")
			results.message = "Hidey ho!";
			if( results.sleepTime ){
				sleep( results.sleepTime );
			}
		} catch( any e ){
			writeLog("OH NOES!!!!! #e.message#; #e.detail#");
			results.error = e;
		}
		results.endTS = getTickCount();

		writeLog("returning from call() for task #results.id#");
		return results;
	}

}