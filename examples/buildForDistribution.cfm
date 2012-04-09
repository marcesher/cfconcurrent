<cfimport prefix="tags" taglib="../tags"/>

<tags:template root="../">

	<div class="span9">
	  <div class="hero-unit">
	  	<h1>Building for Distribution</h1>
	   	<p>
			CFConcurrent ships with full examples, an Application.cfc, and tests. To build a zip that contains just the parts of CFConcurrent
			that you need to deploy onto your server, use CFConcurrent's <code>distMinimal</code> ANT target:
		</p>

		<h3>From your IDE</h3>
		<ol>
			<li>In your IDE, drag CFConcurrent/build.xml into the ANT build view</li>
			<li>Run <code>distMinimal</code></li>
			<li>Get CFConcurrent-min.zip from the CFConcurrent/deploy directory</li>
		</ol>

		<h3>From the command line</h3>
		<ol>
			<li>This assumes you have ANT installed and can execute ANT from the command line</li>
			<li><code>> ant distMinimal</code></li>
			<li>Get CFConcurrent-min.zip from the CFConcurrent/deploy directory</li>
		</ol>



	  </div><!-- /hero -->


	</div><!--/span-->


</tags:template>
