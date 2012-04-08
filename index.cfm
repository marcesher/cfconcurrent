<cfimport prefix="tags" taglib="tags"/>

<tags:template root="">
	<div class="span9">
	  <div class="hero-unit">
	    <h1>Welcome to CFConcurrent</h1>
	    <p>
	    	CFConcurrent simplifies the use of the Java Concurrency Framework
			(<a href="http://docs.oracle.com/javase/tutorial/essential/concurrency/executors.html">java tutorial</a> | <a href="http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/package-summary.html">javadoc</a>)
			in ColdFusion applications.
	    </p>
		<p>
			Although CFThread is suitable for management-free, fire-and-forget concurrency, robust production applications
			require higher-level abstractions and a greater degree of control.
			The Java Concurrency Framework (JCF) provides such improvements.
		</p>
		<p>
			You create CFCs that act as "tasks" that return results.
			You submit those tasks to the JCF for execution.
			You can then retrieve the execution results immediately when they are available,
			or you can create a periodic "polling" task which processes the completed results.

			In addition, you can easily create cancelable, pausable scheduled tasks directly in your code,
			freeing you from the 1-minute limitation of ColdFusion's scheduled task implementation.
		</p>
		<p>
			CFConcurrent's goals are:

			<ul>
				<li>Simplify Java object and proxy creation</li>
				<li>Expose common patterns as generic services</li>
				<li>Expose extensible base components</li>
				<li>Do not over-reach</li>
				<li>Limit protectionist instincts</li>
			</ul>
		</p>

		<p>
			Run the examples in the left menu to get started. See the actual code in /cfconcurrent/examples/
		</p>

	   <p><a class="btn btn-primary btn-large" href="https://github.com/marcesher/cfconcurrent" target="_blank">Learn more &raquo;</a></p>
	  </div>

	  <div class="row-fluid">
	    <div class="span4">
	      <h2>Simplify Usage</h2>

	      <p>Turn this:</p>

		  <code>blah</code>

		  <p>into this:</p>

		  <code>yay</code>

	    </div><!--/span-->

	    <div class="span4">
	      <h2>Expose Generic Services</h2>
	       <p>Turn this:</p>

		  <code>blah</code>

		  <p>into this:</p>

		  <code>yay</code>

	    </div><!--/span-->

	    <div class="span4">
	      <h2>Extensible Base Components</h2>
	      <p>Create your own custom services by extending the <code>AbstractExecutorService</code></p>
	    </div><!--/span-->
	  </div><!--/row-->

	</div><!--/span-->
</tags:template>