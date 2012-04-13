<!---Thanks, Twitter Bootstrap! --->

<cfparam name="attributes.root" default="cfconcurrent/">
<cfset root = attributes.root>

<cfoutput>

	<cfif thisTag.executionMode eq "start">

	<!DOCTYPE html>
	<html lang="en">
	  <head>
	    <meta charset="utf-8">
	    <title>CFConcurrent</title>
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">

	    <link href="#root#resources/css/bootstrap.min.css" rel="stylesheet">
	    <style type="text/css">
	      body {
	        padding-top: 60px;
	        padding-bottom: 40px;
	      }
	      .sidebar-nav {
	        padding: 9px 0;
	      }
	    </style>
	    <link href="#root#resources/css/bootstrap-responsive.min.css" rel="stylesheet">

	    <!--[if lt IE 9]>
	      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	    <![endif]-->

	    <link rel="shortcut icon" href="#root#resources/img/favicon.ico">
	  </head>

	  <body>

	    <div class="navbar navbar-fixed-top">
	      <div class="navbar-inner">
	        <div class="container-fluid">
	          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	          </a>
	          <a class="brand" href="">CFConcurrent</a>
	          <div class="nav-collapse">
	            <ul class="nav">
	              <li class="active"><a href="#root#">Home</a></li>
	              <li><a href="https://github.com/marcesher/cfconcurrent">Github Project Page</a></li>
	            </ul>
	          </div><!--/.nav-collapse -->
	        </div>
	      </div>
	    </div>

	    <div class="container-fluid">

	      <div class="row-fluid">
	        <div class="span3">
	          <div class="well sidebar-nav">
	            <ul class="nav nav-list">
	              <li class="nav-header">Examples</li>
	              <li><a href="#root#examples/ExecutorService">Executor Service</a></li>
	              <li><a href="#root#examples/ExecutorCompletionService">Executor Completion Service</a></li>
	              <li><a href="#root#examples/ScheduledThreadPoolExecutor">Scheduled Executor</a></li>
	              <li><a href="#root#ormInExecutor">Using ORM in an Executor Service</a></li>
	              <li><a href="#root#examples/stopAll.cfm">Stop any running Examples services</a></li>
	              <li class="nav-header">Deploying CFConcurrent</li>
	              <li><a href="#root#examples/buildForDistribution.cfm">Build a minimized zip for distribution</a></li>
	            </ul>
	          </div><!--/.well -->
	        </div><!--/span3-->

	</cfif> <!---/ thisTag.start --->

	<!---body will go here --->

	<cfif thisTag.executionMode eq "end">

	      </div><!--/row-fluid-->

	      <hr>

	      <footer>
	        <p>&copy; Marc Esher #year(now())#</p>
	      </footer>

	    </div><!--/.fluid-container-->

	    <script src="resources/js/jquery-1.7.1.min.js"></script>
	    <script src="resources/js/bootstrap.min.js"></script>

	  </body>
	</html>

	</cfif>

</cfoutput>