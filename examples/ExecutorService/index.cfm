<cfimport prefix="tags" taglib="../../tags"/>

<tags:template root="../../">

	<div class="span9">
	  <div class="hero-unit">
	  	<h1>Executor Service</h1>
	   	<p>
			An Executor Service (<a href="http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/ExecutorService.html" target="_blank">javadoc</a>) asynchronously runs tasks that you submit to it.
			Calls to submit() will return a Future (<a href="http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/Future.html">javadoc</a>), and you use the future to track the status and retrieve the result of your task's execution.
		</p>

		<p>
			You use an ExecutorService when you want to submit a Task to be run asynchronously, but you also wish to wait for its result.
		</p>

		<p>
			If you need to submit your task and you do not wish to wait for its result -- but instead plan to have other code process results
			at some other time -- then you want to use a <a href="../CompletionService">Completion Service</a>
		</p>
	  </div><!-- /hero -->

	  <div class="row-fluid">

	    <div class="span4">
	      <h2>Submit a task</h2>
	     <p>
			<a href="submit.cfm?sleepTime=100&waitTime=200">100ms to execute, 200ms before timing out</a>
		</p>
		<p>
			This will submit a new task several different times, demonstrating different scenarios you should expect
			to encounter in your applications
		</p>
	    </div><!--/span-->

	   <!--- <div class="span4">
	      <h2>Current Queue Sizes</h2>
	      <cfoutput>
		  	<p><b>#workQueueSize# tasks in the work queue. #completionQueueSize# tasks in the completion queue.</b></p>
		  </cfoutput>
	    </div><!--/span-->--->

	    <div class="span4">
	      <h2>Re-init the app</h2>
	      <p><a href="index.cfm?reinit">Reinit the app</a></p>
		  <p><b>Note: </b> Application.cfc will shut down the executor onApplicationStop()... Read that code. You <b>must</b> do this in your own code!</p>
	    </div><!--/span-->

	  </div><!--/row-->

	</div><!--/span-->


</tags:template>
