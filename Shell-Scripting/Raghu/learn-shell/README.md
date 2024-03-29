# Learn-Shell

List of Topics
1. Comments
2. Print
3. Variables
4. Functions
5. Conditions
6. Exit Status & Redirections & Quote
7. SED Editor


---------------------------------------------------------------------------------------------
#!/bin/bash - Knows as shebang it tells the OS that this script should be executed using the Bash Shell.

bash -n script.sh # Dry run if no error then no output.
bash -u script.sh # It will check for variables weather it defined or not.
bash -x script.sh # Debug mode or Execution Traces.

Non Functional Requirements (NFR)
* Keep code DRY.
* Username and Password not to be hardcoded.
* Rerun of code should not fail.

---------------------------------------------------------------------------------------------

Input Output Redirection.
* < : This arrow determines input to system (<).
* Ex: loading the schema mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js
* > : This arrow determines output to a file (>).
  
--------------------------------------------------------------------------------------------
Four foundation pillar of every scripting is VFCL.
* Variables
* Functions
* Conditions
* Loop

--------------------------------------------------------------------------------------------
When we have some repetitive content then we can declare that in a variable, and we can use that variable reference avery where. Advantage is, if change in place that impacts all the places where that value is used.

If we assign a name to a set of data is called as variable
a=10
name=abhi
pass=abhi123
* In shell do not have data types (10, john). Simply we can declare value
* Variables names (a, name) should be using alphabets and number and _(underscore).
* If values are having any special character then double quote it.
* space is also a special character

How to access the variable
* Access variable with $ as prefix and also optionally variable name in flower braces.
* $VAR or ${VAR}
