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
