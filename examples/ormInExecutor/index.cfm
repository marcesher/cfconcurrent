<h1>
	What works
</h1>

<p>
	Currently, you can entityLoad objects prior to initializing your task. Inject those objects into your task, and then pass the task to the executor.

	The task will be able to entitySave() any updates it makes to the task.

	Bottom line: Insert/Update/Delete works

</p>

<h1>
	What does not work
</h1>

<p>
	entityLoad() does not work. I have submitted a bug to adobe
</p>
<!---<cfdump var="#application.executorCompletionService#" expand="false">--->