<cfimport prefix="tags" taglib="../../tags"/>

<tags:template root="../../">

	<div class="span9">
	  <div class="hero-unit">
	  	<h1>Scheduled Executor</h1>
	   	<p>
			A Scheduled Executor (<a href="http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/ScheduledThreadPoolExecutor.html" target="_blank">javadoc</a>)
			asynchronously runs tasks that you submit to it, on a schedule.

			Calls to the various schedule() methods will return a ScheduledFuture (<a href="http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/ScheduledFuture.html" target="_blank">javadoc</a>), and you can use the future to track the status of your task's execution. You also use the ScheduledFuture to cancel the task.
		</p>

		<p>
			You use a Scheduled Executor when you want to submit a Task to be run periodically. A common idiom is to use a Scheduled Executor to periodically check for work to be done
			in some type of workflow system. When work is found, the scheduled task can then use its own <a href="../ExecutorService">Executor Service</a>
			or <a href="../CompletionService">Completion Service</a> to asynchronously execute the work it finds.
		</p>

		<p>
			Executor and Completion Services are for one-time tasks. Scheduled Executors are used for a small number of tasks expected to be run repeatedly on a schedule.
		</p>
	  </div><!-- /hero -->

	  <div class="row-fluid">

	    <div class="span4">
	      <h2>Current Running Task</h2>
		     <p>
				When this application initializes, a new SimpleRunnableTask is scheduled to run every few seconds.
				It keeps an internal count of the number of times it has run.
			</p>
			<p>
				The task's current details are:

				<cfdump var="#application.task1.getResults()#" label="Task1 Run Count: #application.task1.getResults().runCount#">
			</p>
	    </div><!--/span-->

	   <div class="span4">
	      <h2>Cancel this task</h2>

	      <p>
	      	CFConcurrent simplifies the cancelling of scheduled tasks. Click to <a href="cancelAndRenew.cfm">cancel the task</a> scheduled at app start and start a new task
	      </p>
		  <p>
		  	You'll land back on this screen, and you'll notice the created timestamp and runcount will have changed, indicating a new object.
		  </p>
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
