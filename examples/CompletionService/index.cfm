<cfimport prefix="tags" taglib="../../tags"/>

<cfset workQueueSize = application.completionService.getWorkQueue().size()>
<cfset completionQueueSize = application.completionService.getCompletionQueue().size()>


<tags:template root="../../">

	<div class="span9">
	  <div class="hero-unit">
	  	<h1>Executor Completion Service</h1>
	   <p>
			An Executor Completion Service (<a href="http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/ExecutorCompletionService.html" target="_blank">javadoc</a>)
			asynchronously runs tasks that you submit to it. It puts the completed results into a Completion Queue, which you occassionally poll.
		</p>

		<p>
			Polling the completion queue returns a Future (<a href="http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/Future.html">javadoc</a>) for each completed Task,
			and you can call get() on that future to fetch the result.
		</p>

		<p>
			CFConcurrent makes this all even easier. You needn't write the polling code... you simply write a "publisher" CFC that exposes a "publish( array_of_results )" method,
			and whenever the completion queue is polled, it'll send the results to your publish() implementation.
		</p>
		<p>
			If you need to submit your task and need to wait for its result -- and you do not need your tasks to be put into a completion queue for later processing,
			 then you should use the simpler <a href="../ExecutorService">Executor Service</a>
		</p>
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
	      <h2>Stop or Re-init the app</h2>
	      <p><a href="index.cfm?stop">Stop the app</a></p>
	      <p><a href="index.cfm?reinit">Reinit the app</a></p>
		  <p><b>Note: </b> Application.cfc will shut down the executor onApplicationStop()... Read that code. You <b>must</b> do this in your own code!</p>
	    </div><!--/span-->

	  </div><!--/row-->

	</div><!--/span-->


</tags:template>