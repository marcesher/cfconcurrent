component output="false" accessors="true"{
	
	property name="cfcDynamicProxy"; 
	
	supportsNativeProxy = structKeyExists( getFunctionList(), "createDynamicProxy" );
	callableInterfaces = ["java.util.concurrent.Callable"];
	runnableInterfaces = ["java.lang.Runnable"];	
	variables.serverScopeName = "__cfconcurrentJavaLoader";
	
	public function init(){
		if( NOT supportsNativeProxy ){
			writeLog("Native createDynamicProxy not supported... falling back to JavaLoader. All Hail Galaxar! er... Mark Mandel!");
			structDelete( server, variables.serverScopeName );
			var proxyJarPath = getDirectoryFromPath( getCurrentTemplatePath() ) & "/javaloader/support/cfcdynamicproxy/lib/cfcdynamicproxy.jar";
			var paths = [proxyJarPath];
			server[variables.serverScopeName] = new javaloader.JavaLoader( loadPaths = paths, loadColdFusionClassPath = true );

			variables.CFCDynamicProxy = getJavaloader().create( "com.compoundtheory.coldfusion.cfc.CFCDynamicProxy" );
		}
		return this;
	}

	public function createRunnableProxy( object ){
		return createProxy( object, runnableInterfaces );
	}
	
	public function createCallableProxy( object ){
		return createProxy( object, callableInterfaces );
	}
	
	
	public function createProxy( object, interfaces ){
		if( supportsNativeProxy ){
			return createDynamicProxy( arguments.object, arguments.interfaces );
		} else {
			return cfcDynamicProxy.createInstance( arguments.object, arguments.interfaces );
		}
	}
	
	public function getJavaLoader(){
		return server[variables.serverScopeName];
	}
}