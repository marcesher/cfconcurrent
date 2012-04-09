Welcome to CFConcurent
======================

CFConcurrent simplifies the use of the Java Concurrency Framework
([java tutorial](http://docs.oracle.com/javase/tutorial/essential/concurrency/executors.html) | [javadoc](http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/package-summary.html))
in ColdFusion applications.


Although CFThread is suitable for management-free fire-and-forget concurrency, robust production applications
require higher-level abstractions and a greater degree of control.
The Java Concurrency Framework (JCF) provides such improvements, and you can take advantage of it using *100% CFML*.

You create CFCs that act as "tasks" that return results.
You submit those tasks to the JCF for execution.
You can then retrieve the execution results immediately when they are available,
or you can create a periodic "polling" task which processes the completed results.

In addition, you can easily create cancelable, pausable scheduled tasks directly in your code (think: heartbeats, daemons),
freeing you from the 1-minute limitation of ColdFusion's scheduled task implementation.

CFConcurrent's goals are:

* Simplify Java object and proxy creation
* Expose common patterns as generic services
* Expose extensible base components
* Do not over-reach
* Limit protectionist tendencies

Usage
--------

You want to see code. CFConcurrent ships with running examples and a suite of MXUnit tests. Docs are in the wiki: https://github.com/marcesher/cfconcurrent/wiki. 


Support or Contact
------------------

Post issues to https://github.com/marcesher/cfconcurrent/issues. 
Pull requests should have accompanying MXUnit tests.
