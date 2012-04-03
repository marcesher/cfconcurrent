<cfset result = entityLoad("Artist")>
<cfdump var="#result#">

<cfset result[1].setThePassword( left(getTickCount(), 8) )>

<cftransaction>
	<cfset entitySave(result[1])>
</cftransaction>