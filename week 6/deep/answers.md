# From the Deep

In this problem, you'll write freeform responses to the questions provided in the specification.

## Random Partitioning

With large enough dataset, this approach avoid a query hotspot when making use of all database server (boats). And researchers may still be able to find insights from sufficient data amount in any given boats. However, if a specific range of data are required, and sample size is prioritized, the time required to gather as much as possible data is longer. To conclude, this approach is in favor of writing but not reading.


## Partitioning by Hour

This is the exact opposite case of the random partitioning. By clustering similar data, it favors faster query of specific data.  But a lower capacity and speed of data processing as a hotspot is created. Both the writing and reading query is heavy, as well as the memory drawback for the boat A. And some of the servers can economically inefficient.

## Partitioning by Hash Value

This seems like the best solution when comparing to those 2 above. As researchers can make use of all boats when both inputing data to the boat, and reading specific data from all boats by using hash function. However, we know that using a hashmap is like using an index in querying, this greatly increase the volume of the database (or the researchers need extra space for saving the hash value).