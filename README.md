# SVA_GEN
An SVA generator from CSV file using Cshell
* Keyword: ignore, special, start, stop, _num, _end.
* For ignoring an property: add ignore keyword in the first column of that assertions. 
* For unique property: add special keyword in the first column of that assertions. (not required)
* When using multiple assertions:                     
    + Add start and stop keyword in the first column of that assertions. (not required)
    + Add _num keyword in the column after the sensitive signals that need numbering.
    + The ordinal numbers is added in the following column.
* Add _end in the last column of each assertions need generating
