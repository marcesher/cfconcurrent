<!---start a new one; note that a previously scheduled task with the same name will automatically be cancelled prior to scheduling a new one --->
<cfset application.task1 = createObject("component", "SimpleRunnableTask").init( "task1" )>
<cfset application.executorService.scheduleAtFixedRate("task1", application.task1, 0, 2, application.executorService.getObjectFactory().SECONDS)>

<cflocation url="index.cfm" addtoken="false">