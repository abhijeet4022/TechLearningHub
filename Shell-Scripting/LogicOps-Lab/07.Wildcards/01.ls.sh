#!/bin/bash

cd MyFiles

# lists all files with .txt extension
ls *.txt

# lists all files that starts with a with .txt extension
ls a*.txt

# lists all files that starts with b
ls b*

# lists all files that are of 1 character
# If single character file is not available then it will give error like this.
# ls: cannot access '?': No such file or directory
ls ?

# files with the name of 2 characters
# If double character file is not available then it will give error like this.
# ls: cannot access '??': No such file or directory
ls ?? 

ls c?.txt
ls c*.txt

