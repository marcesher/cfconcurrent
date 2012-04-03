component{

	results = { created = now(), createTS = getTickCount(), error={} };

	function init( id ){
		results.id = arguments.id;
		return this;
	}

	function call(){
		try{
			writeLog("Inside call!")
			results.anObject = createObject("component", "ACFC");
			results.anObject.createAnother();

			//ensure we can create objects from different packages
			results.anObjectFromDifferentPackage = createObject("component", "cfconcurrent.examples.ormInExecutor.model.ACFC");
			results.anObjectFromDifferentPackage.createAnother();
		} catch( any e ){
			writeLog("OH NOES!!!!! #e.message#; #e.detail#");
			results.error = e;
		}
		results.endTS = getTickCount();

		writeLog("returning from call() for task #results.id#");
		return results;
	}

}