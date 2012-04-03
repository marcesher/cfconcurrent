<cfsetting showdebugoutput="false">
<cfparam name="url.sleepTime" default="100">
<cfparam name="url.taskCount" default="25">

<cfimport prefix="tags" taglib="../../tags"/>

<cfset idStub = createUUID()>

<cfloop from="1" to="#val(url.taskCount)#" index="i">

	<cfif url.sleepTime eq "random">
		<cfset url.sleepTime = randRange(50, 500)>
	</cfif>

	<cfset task = new HelloTask( idStub & "_#i#", val(url.sleepTime) )>
	<cfset future = application.completionService.submitCallable( task )>
</cfloop>

<cfset workQueueSize = application.completionService.getWorkQueue().size()>
<cfset completionQueueSize = application.completionService.getCompletionQueue().size()>


<tags:template root="../../">

	<div class="span9">
	  <div class="hero-unit">
	  	<h1><cfoutput>#url.taskCount# tasks submitted</cfoutput></h1>
	   <p>
			Watch your CF Console...
		</p>

		<p>Here we submit new tasks to the completion service. The Completion Task is configured in Application.cfc to run every 2 seconds.
		Watch your CF Log to see the output of the publish() method.</p>
	  </div><!-- /hero -->

	  <div class="row-fluid">

	    <div class="span4">
	      <h2>Submit some tasks</h2>
	      <p><a href="submit.cfm?sleepTime=100&taskCount=25">25 tasks, each taking 100ms to execute</a></p>
		  <p>After you submit, you can fiddle with the URL params and reload the page, trying different scenarios</p>
		  <p>Use "sleepTime=random" to randomize the sleep time</p>
	    </div><!--/span-->

	    <div class="span4">
	      <h2>Current Queue Sizes</h2>
	      <cfoutput>
		  	<p><b>#workQueueSize# tasks in the work queue. #completionQueueSize# tasks in the completion queue.</b></p>
		  </cfoutput>
	    </div><!--/span-->

	    <div class="span4">
	      <h2>Re-init the app</h2>
	      <p><a href="index.cfm?reinit">Reinit the app</a></p>
		  <p><b>Note: </b> Application.cfc will shut down the executor (and start a new one) onApplicationStop()... Read that code. You <b>must</b> do this in your own code!</p>
	    </div><!--/span-->

	  </div><!--/row-->

	</div><!--/span-->


</tags:template>



