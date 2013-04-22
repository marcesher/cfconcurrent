<cfcomponent accessors="true">
	
	<cfproperty name="result">
	<cfset result = "">
	
	<cffunction name="call" output="false" access="public" returntype="any" hint="">    
    	<cflog text="Starting...">
		<cfset var q = "">
		<cfquery datasource="nfpors3" name="q">
			select top 10 * from v_ActivityTreatmentDump
		</cfquery>
		<cflog text="Finished Query...">
		<cfset result = q>
		<cfreturn q.recordCount>
    </cffunction>
</cfcomponent>