<cfscript>
directoryDelete( expandPath("api"), true);
colddoc = createObject("component", "colddoc.ColdDoc").init();
strategy = createObject("component", "colddoc.strategy.api.HTMLAPIStrategy").init( expandPath("api"), "CFConcurrent" );
colddoc.setStrategy(strategy);
colddoc.generate(expandPath("/cfconcurrent"), "cfconcurrent", false);
</cfscript>
