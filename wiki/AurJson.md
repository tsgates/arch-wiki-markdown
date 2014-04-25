AurJson
=======

The AurJson interface is a lightweight remote interface for the AUR. It
utilizes http GET queries as the request format, and json as the
response data exchange format.

Contents
--------

-   1 API Usage
    -   1.1 Query Types
        -   1.1.1 search
        -   1.1.2 msearch
        -   1.1.3 info
        -   1.1.4 multiinfo
    -   1.2 Return Types
        -   1.2.1 error
        -   1.2.2 search
        -   1.2.3 msearch
        -   1.2.4 info
        -   1.2.5 multiinfo
    -   1.3 jsonp
-   2 More Examples
-   3 Reference Clients
-   4 See also

API Usage
---------

The RPC interface has four major query types:

-   search
-   msearch
-   info
-   multiinfo

Each method requires the following HTTP GET syntax:

    type=methodname&arg=data

Where methodname is the name of an allowed method, and data is the
argument to the call.

Data is returned in json encapsulated format.

> Query Types

As noted above, there are four query types:

-   search
-   msearch
-   info
-   multiinfo

search

A search type query takes an argument of a string with which to perform
a package search. Possible return types are error and search.

Example:

    http://aur-url/rpc.php?type=search&arg=foobar

The above is a query of type search and the search argument is "foobar".

msearch

A msearch type query takes an argument of a string with which to perform
a search by maintainer name. Possible return types are error and
msearch.

Example:

    http://aur-url/rpc.php?type=msearch&arg=cactus

The above is a query of type msearch and the search argument is
"cactus".

info

An info type query takes an argument of a string or an integer. If an
integer, the integer must be an exact match to an existing packageID, or
an error type is returned. If a string, the string must be an exact
match to an existing packageName, or an error type is returned.

Examples:

    http://aur-url/rpc.php?type=info&arg=1123
    http://aur-url/rpc.php?type=info&arg=foobar

The two examples above are both queries of type info. The first query is
using an integer type argument, and the second is using a packageName
argument. If packageID 1123 corresponded to packageName foobar, then
both of the above queries would return the details of the foobar
package.

multiinfo

The majority of "real world" info requests come in hefty batches. AUR
can handle these in one request rather than multiple by allowing AUR
clients to send multiple arguments.

Examples:

    http://aur-url/rpc.php?type=multiinfo&arg[]=cups-xerox&arg[]=cups-mc2430dl&arg[]=10673

> Return Types

The return payload is of one format, and currently has five main types.
The response will always return a type so that the user can determine if
the result of an operation was an error or not.

The format of the return payload is:

    {"type":ReturnType,"results":ReturnData}

ReturnType is a string, and the value is one of:

    * error
    * search
    * msearch
    * info
    * multiinfo

The type of ReturnData is dependent on the query type:

-   If ReturnType is error then ReturnData is a string.
-   If ReturnType is search then ReturnData is an array of dictionary
    objects.
-   If ReturnType is msearch then ReturnData is an array of dictionary
    objects.
-   If ReturnType is info then ReturnData is a single dictionary object.
-   If ReturnType is multiinfo then ReturnData is an array of dictionary
    objects.

error

The error type has an error response string as the return value. An
error response can be returned from either a search or an info query
type.

Example of ReturnType error:

    {"type":"error","results":"No results found"}

search

The search type is the result returned from a search request operation.
The actual results of a search operation will be the same as an info
request for each result. See the info section.

Example of ReturnType search:

    {"type":"search","results":[{"Name":"pam_abl","ID":1995, ...}]}

msearch

The msearch type is the result returned from an msearch request
operation. The actual results of an msearch operation will be the same
as an info request for each result. See the info section.

Example of ReturnType msearch:

    {"type":"msearch","results":[{"Name":"pam_abl","ID":1995, ...}]}

info

The info type is the result returned from an info request operation.
Returning the type as search is useful for detecting whether the
response to a search operation is search data or an error.

Example of ReturnType info:

     {
        "type": "info",
        "results": {
            "URL": "http://pam-abl.deksai.com/"
            "Description": "Automated blacklisting on repeated failed authentication attempts"
            "Version": "0.4.3-1"
            "Name": "pam_abl"
            "FirstSubmitted": 1125707839
            "License": "BSD GPL"
            "ID": 1995
            "OutOfDate": 0
            "LastModified": 1336659370
            "Maintainer": "redden0t8"
            "CategoryID": 16
            "URLPath": "/packages/pa/pam_abl/pam_abl.tar.gz"
            "NumVotes": 10
        }

     }
     

multiinfo

The multiinfo type is the result returned from a multiinfo request
operation. The actual results of a multiinfo operation will be the same
as an info request for each result. See the info section.

Example of ReturnType multiinfo:

    {"type":"multiinfo","results":[{"Name":"pam_abl","ID":1995, ...}]}

> jsonp

If you are working with a javascript page, and need a json callback
mechanism, you can do it. You just need to provide an additional
callback variable. This callback is usually handled via the javascript
library, but here is an example.

Example Query:

    http://aur-url/rpc.php?type=search&arg=foobar&callback=jsonp1192244621103

Example Result:

    jsonp1192244621103({"type":"error","results":"No results found"})

This would automatically call the JavaScript function jsonp1192244621103
with the parameter set to the results of the RPC call. (In this case,
{"type":"error","results":"No results found"})

More Examples
-------------

Example Query and Result:

     http://aur-url/rpc.php?type=search&arg=foobar
     {"type":"error","results":"No results found"}
     

Example Query and Result:

     http://aur-url/rpc.php?type=search&arg=pam_abl
     {"type":"search","results":[{"Name":"pam_abl","ID":1995}]}
     

Example Query and Result:

     http://aur-url/rpc.php?type=info&arg=pam_abl
     {
        "type": "info",
        "results": {       
            "Description": "Provides auto blacklisting of hosts and users responsible for repeated failed authentication attempts", 
            "ID": 1995, 
            "License": "", 
            "Name": "pam_abl", 
            "NumVotes": 4,
            "OutOfDate": 0,
            "URL": "http://www.hexten.net/pam_abl",
            "URLPath": "/packages/pam_abl/pam_abl.tar.gz",
            "Version": "0.2.3-1"
        }
     }
     

Reference Clients
-----------------

Sometimes things are easier to understand with examples. A few reference
implementations (jQuery, python, ruby) are available at the following
url: https://github.com/cactus/random/tree/master/aurjson_examples

See also
--------

-   Official Repositories Web Interface

Retrieved from
"https://wiki.archlinux.org/index.php?title=AurJson&oldid=280380"

Category:

-   Package management

-   This page was last modified on 30 October 2013, at 11:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
