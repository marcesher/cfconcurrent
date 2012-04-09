
<cfparam name="url.sleepTime" default="100">
<cfparam name="url.waitTime" default="200">

<cfscript>
/*Example 1: submit() with timeout */
task = new HelloTask( url.sleepTime );
future = application.executorService.submit( task );
callResultWithTimeout = future.get( url.waitTime, application.executorService.getTimeUnit().MILLISECONDS );

/*Example 2: submit() with no timeout*/
task = new HelloTask( url.sleepTime );
future = application.executorService.submit( task );
callResultWithNoTimeout = future.get();

/*Example 3: submit() with a task that catches an error and includes it in the result*/
task = new HelloTask( 0, true, true );
future = application.executorService.submit( task );
resultWithCaughtError = future.get();

/*Example 4: submit() with a task that throws an error... note that the call to future.get() will cause the error to be re-thrown*/
task = new HelloTask( 0, true );
future = application.executorService.submit( task );
try{
	result = future.get();
} catch( any e ){
	resultWithThrownError = duplicate(e);
}

/*Example 5: invokeAll() with no timeout, which runs all submitted tasks in it the thread pool but which blocks till completion*/
tasks = [];
for( i = 1; i <= 10; i++ ){
	arrayAppend( tasks, new HelloTask( 1 ) );
}

futures = application.executorService.invokeAll( tasks );
/*for display purposes, stuff all the "get()" results into an array so we can collapse it*/
invokeAllResultsWithNoTimeout = [];
for( future in futures ){
	arrayAppend( invokeAllResultsWithNoTimeout, future.get() );
}

/*Example 6: invokeAll() with timeout*/
tasks = [];
for( i = 1; i <= 25; i++ ){
	arrayAppend( tasks, new HelloTask( 15 ) );
}

futures = application.executorService.invokeAll( tasks, 15, "milliseconds" );
/*for display purposes, stuff all the "get()" results into an array so we can collapse it*/
invokeAllResultsWithTimeout = [];
for( future in futures ){
	try{
		arrayAppend( invokeAllResultsWithTimeout, future.get() );
	} catch( any e ){
		arrayAppend( invokeAllResultsWithTimeout, duplicate(e) );
	}
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

	    </div><!--/span-->

	   <div class="span4">

			<h2>Submitting and using get() with no timeout</h2>
			<p>Example 2: Sometimes you want to wait for the task to complete regardless of how long it takes</p>

			<cfdump var="#callResultWithNoTimeout#" expand="false" label="Click to Expand">

	    </div><!--/span-->


	    <div class="span4">
	      <h2>Stop or Re-init the app</h2>
	      <p><a href="index.cfm?stop">Stop the app</a></p>
	      <p><a href="index.cfm?reinit">Reinit the app</a></p>
		  <p><b>Note: </b> Application.cfc will shut down the executor onApplicationStop()... Read that code. You <b>must</b> do this in your own code!</p>
	    </div><!--/span-->

	  </div><!--/row-->


	  <div class="row-fluid">

	    <div class="span4">

		 	<h2>Submitting a task that throws an error and catches it</h2>
			<p>Example 3: Sometimes your code will error. If you try/catch it, you can stick the error object into the result you return</p>

			<cfdump var="#resultWithCaughtError#" expand="false" label="Click to Expand">

	    </div><!--/span-->

	   <div class="span4">

			<h2>Submitting a task that throws an error but does not catch it</h2>
			<p>Example 4: If you don't catch your errors, the call to get() will thus throw the error

			<cfdump var="#resultWithThrownError#" expand="false" label="Click to Expand">

	    </div><!--/span-->

	  </div><!--/row-->

	  <div class="row-fluid">

	    <div class="span4">

		 	<h2>invokeAll() to run multiple tasks and await results</h2>
			<p> Example 5:
				It's common to have a group of tasks you want to run "as a group" and await all of their results.
				When using CFThread, this is typically achieved with thread.run(); thread.join();
				Using the JCF, you use <code>invokeAll( tasks, timeout, timeUnit );</code>
			</p>

			<cfdump var="#invokeAllResultsWithNoTimeout#" expand="false" label="Click to Expand">

	    </div><!--/span-->

	   <div class="span4">

			<h2>invokeAll() with a timeout</h2>
			<p>Example 6: You can specify a timeout for invokeAll(). Any submitted tasks that do not complete
			within that timeout will throw an exception.

			Note: The last few elements in this array should be exceptions and not call results
			</p>

			<cfdump var="#invokeAllResultsWithTimeout#" expand="false" label="Click to Expand">

	    </div><!--/span-->

	  </div><!--/row-->

	</div><!--/span-->


</tags:template>















