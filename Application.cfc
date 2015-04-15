component{

	this.name = "cfconcurrent";
	root = getDirectoryFromPath(getCurrentTemplatePath());

	function onApplicationStart(){
	}

	function onRequestStart(){
		if( structKeyExists(url, "reinit") ){
			applicationStop();
		}
	}

	function onApplicationEnd(required struct applicationScope){
	}
	
}
