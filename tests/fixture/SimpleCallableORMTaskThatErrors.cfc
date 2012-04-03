component{

	results = { created = now(), createTS = getTickCount(), error={}, fetched="" };

	function init( id ){
		results.id = arguments.id;
		return this;
	}

	function call(){
		try{
			writeLog("Inside call!")

			var fc = createObject("java", "coldfusion.filter.FusionContext").init();
			fc.getCurrent().setApplicationName("cfconcurrent_tests");

			var newArtist = new cfconcurrent.examples.ormInExecutor.model.Artist() ;

			//results.fetched = entityLoadByPk("Artist", results.id );

		} catch( any e ){
			writeLog("OH NOES!!!!! #e.message#; #e.detail#");
			results.error = e;
		}
		results.endTS = getTickCount();

		writeLog("returning from call() for task #results.id#");
		return results;
	}

}