component{

	results = { created = now(), createTS = getTickCount(), error={}, fetched="", saved=false };

	function init( id ){
		results.id = arguments.id;
		results.entity = entityLoadByPk( "Artist", arguments.id );
		return this;
	}

	function call(){
		try{
			writeLog("Inside call!")

			var fc = createObject("java", "coldfusion.filter.FusionContext").init();
			fc.getCurrent().setApplicationName("cfconcurrent");

			var pw = left(getTickCount(), 8);
			results.password = pw;

			results.entity.setThePassword(pw);
			transaction{
				entitySave(results.entity);
				results.saved = true;
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