component{

	results = { created = now(), createTick = getTickCount(), error={}, runCount = 0 };
	
	function init( id ){
		results.id = arguments.id;
		return this;
	}
	
	function run(){
		try{
			results.runCount++;
			writeLog("Inside run for id #results.id#! RunCount is now #results.runCount#")
		} catch( any e ){
			writeLog("OH NOES!!!!! #e.message#; #e.detail#");
			results.error = e;
		}
		results.lastTick = getTickCount();
		
	}
	
	function getResults(){
		return results;
	}

}