<!---cancel it --->
<cfset application.executorService.cancelTask( "task1" )>

<!---start a new one --->
<cfset application.task1 = createObject("component", "SimpleRunnableTask").init( "task1" )>
<cfset application.executorService.scheduleAtFixedRate("task1", application.task1, 0, 2, "seconds")>

<cflocation url="index.cfm" addtoken="false">