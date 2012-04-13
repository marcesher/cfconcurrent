<cfscript>

//entityLoadByPk("Artist", 1);

for(i=1; i<=5;i++){

	task = createObject("component", "cfconcurrent.examples.ormInExecutor.model.EntityLoadingTask").init( randRange(1,10) );
	application.executorCompletionService.submit( task );
}
</cfscript>
