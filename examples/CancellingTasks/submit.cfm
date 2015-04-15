
<cfparam name="url.sleepTime" default="100">
<cfparam name="url.waitTime" default="200">

<cfscript>
objectFactory = application.executorService.getObjectFactory();

/*Example 1: submit() with timeout */
task = new QueryTask( getTickCount() );

future = application.executorService.submit( task );
try{
	callResultWithTimeout = future.get( url.waitTime, objectFactory.MILLISECONDS );
	
} catch(any e){
	callResultWithTimeout = e;
	future.cancel(true);
}



</cfscript>


<cfimport prefix="tags" taglib="../../tags"/>

<tags:template root="../../">

	<div class="span9">
	  <div class="hero-unit">
	  	<h1>Task Submitted</h1>

	   	<p>Fiddle with the sleepTime and waitTime url params to see what happens when the timeout kicks in.</p>

		<p>
			This shows what happens with different scenarios you'll encounter when working with tasks.
		</p>
	  </div><!-- /hero -->

	  <div class="row-fluid">

	    <div class="span4">

		  <h2>Submitting and using get() with a timeout</h2>
			<p>Example 1: Sometimes you want the task to cancel if it doesn't complete after a certain time period</p>
			<p>NOTE: It is the expected, <a href="http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/Future.html#get(long, java.util.concurrent.TimeUnit)" target="_blank">documented behavior</a> that it'll throw an exception when the get() times out prior to completing</p>

			<cfdump var="#callResultWithTimeout#" expand="false" label="Click to Expand">
			
			<cfdump var="#task.getResult()#">

	    </div><!--/span-->



	    <div class="span4">
	      <h2>Stop or Re-init the app</h2>
	      <p><a href="index.cfm?stop">Stop the app</a></p>
	      <p><a href="index.cfm?reinit">Reinit the app</a></p>
		  <p><b>Note: </b> Application.cfc will shut down the executor onApplicationEnd()... Read that code. You <b>must</b> do this in your own code!</p>
	    </div><!--/span-->

	  </div><!--/row-->



	</div><!--/span-->


</tags:template>















