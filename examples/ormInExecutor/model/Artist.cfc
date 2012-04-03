<cfcomponent persistent="true" table="Artists">
    <cfproperty name="id" column = "ARTISTID" generator="increment">
    <cfproperty name="FIRSTNAME">
    <cfproperty name="LASTNAME">
    <cfproperty name="ADDRESS">
    <cfproperty name="CITY">
    <cfproperty name="STATE">
    <cfproperty name="POSTALCODE">
    <cfproperty name="EMAIL">
    <cfproperty name="PHONE">
    <cfproperty name="FAX">
    <cfproperty name="thepassword">
</cfcomponent>