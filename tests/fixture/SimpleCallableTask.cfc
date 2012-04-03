component{

	results = { created = now(), createTS = getTickCount(), error={} };
	
	function init( id ){
		results.id = arguments.id;
		return this;
	}
	
	function call(){
		try{
			writeLog("Inside call!")
			results.message = "Hidey ho!";
		} catch( any e ){
			writeLog("OH NOES!!!!! #e.message#; #e.detail#");
			results.error = e;
		}
		results.endTS = getTickCount();
		
		writeLog("returning from call() for task #results.id#");
		return results;
	}

}