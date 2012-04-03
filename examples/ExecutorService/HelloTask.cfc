component{

	result = {startTick = getTickCount(), startTS = now()};

	function init(sleepTime=10, throwAnError = false, catchError = false){
		structAppend( variables, arguments );
		return this;
	}

	function call(){
		result.callStartTick = getTickCount();
		result.message = "Sleeping for #sleepTime# ms";
		sleep( sleepTime );

		if( throwAnError ){
			try{
				throw("you told me to throw, so I'm throwing");
			} catch( any e ){
				if( catchError ){
					result.error = e;
				} else {
					throw( object = e );
				}
			}
		}

		result.endTick = getTickCount();
		return result;
	}

}