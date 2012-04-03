component{

	this.name = "cfconcurrent";
	root = getDirectoryFromPath(getCurrentTemplatePath());


	/*//for ORM tests and examples*/
	this.ormEnabled = true;
	this.datasource = "cfartgallery";
	ormPaths = ["/cfconcurrent/examples/ormInExecutor/model"];
	this.ormSettings = {cfclocation=ormPaths,flushAtRequestEnd = false, automanageSession = false, logsql = true};


	function onApplicationStart(){
	}

	function onRequestStart(){
		if( structKeyExists(url, "reinit") ){
			applicationStop();
			onApplicationStop();

		}
	}

	function onApplicationStop(){
	}

}