
<cfparam name="url.sleepTime" default="100">
<cfparam name="url.waitTime" default="200">


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

			<cfset task = new HelloTask( url.sleepTime )>
			<cfset future = application.executorService.submit( task )>
			<cfset result = future.get( url.waitTime, application.executorService.getTimeUnit().MILLISECONDS )>

			<cfdump var="#result#" expand="false" label="Click to Expand">


	    </div><!--/span-->

	   <div class="span4">

			<h2>Submitting and using get() with no timeout</h2>
			<p>Example 2: Sometimes you want to wait for the task to complete regardless of how long it takes</p>

			<cfset task = new HelloTask( url.sleepTime )>
			<cfset future = application.executorService.submit( task )>
			<cfset result = future.get()>
			<cfdump var="#result#" expand="false" label="Click to Expand">

	    </div><!--/span-->

	  </div><!--/row-->


	  <div class="row-fluid">

	    <div class="span4">

		 	<h2>Submitting a task that throws an error and catches it</h2>
			<p>Example 3: Sometimes your code will error. If you try/catch it, you can stick the error object into the result you return</p>

			<cfset task = new HelloTask( 0, true, true )>
			<cfset future = application.executorService.submit( task )>
			<cfset result = future.get()>
			<cfdump var="#result#" expand="false" label="Click to Expand">


	    </div><!--/span-->

	   <div class="span4">

			<h2>Submitting a task that throws an error but does not catch it</h2>
			<p>Example 4: If you don't catch your errors, the call to get() will thus throw the error

			<cfset task = new HelloTask( 0, true )>
			<cfset future = application.executorService.submit( task )>
			<cftry>
				<cfset result = future.get()>
			<cfcatch>
				<cfdump var="#cfcatch#" expand="false" label="CFCATCH">
			</cfcatch>
			</cftry>

	    </div><!--/span-->

	    <div class="span4">
	      <h2>Stop or Re-init the app</h2>
	      <p><a href="index.cfm?stop">Stop the app</a></p>
	      <p><a href="index.cfm?reinit">Reinit the app</a></p>
		  <p><b>Note: </b> Application.cfc will shut down the executor onApplicationStop()... Read that code. You <b>must</b> do this in your own code!</p>
	    </div><!--/span-->

	  </div><!--/row-->

	</div><!--/span-->


</tags:template>















