<cfdirectory action="list" directory="#expandPath('./')#" name="thisDir" type="dir">

<!---<cfdump var="#thisDir#">--->

<cfset baseDir = replace(cgi.script_name, "stopAll.cfm", "", "one")>
<cfset baseURL = "http://#cgi.server_name#:#cgi.server_port#/#baseDir#/">




<cfimport prefix="tags" taglib="../tags"/>

<tags:template root="../">

	<div class="span9">
	  <div class="hero-unit">
	  	<h1>Results</h1>

	   <cfoutput>#baseURL#</cfoutput>

		<cfoutput query="thisDir">
			<cfset thisURL = "#baseURL##thisDir.name#/index.cfm?stop">
			<p>Running #thisURL#
			<cfhttp method="get" url="#thisURL#">
			<br>
			Status: #cfhttp.StatusCode#
		</cfoutput>
	  </div><!-- /hero -->

	</div><!--/span-->


</tags:template>




