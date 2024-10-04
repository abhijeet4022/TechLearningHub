a=10
echo "value of a is $a"

# Special Variables
# $0 -$N, $*, $#

# Substitution Variables
## Command Substitution
DATE=$(date)

echo Today Date is $DATE

# Arithmetic Substitution
ADD=$(( 2+2 ))
echo ADD of 2+2 = $ADD



# Access environment variable

env # Is the command to list all environment variable.

echo $variablename

# To declare the environment variables now it will consider for script.
variable-name=value
export variablename=value

# Now try to access the variable again.
echo $variablename

#variable
a=10
echo "a is $a"

#log=/tmp/roboshop.log
#cat $log # it will give the /tmp/roboshop.log file output

#Special Variables
# $0 - $N, &*, $#

#Substitution Variables
## Command Substitute
DATE=$(date)   #Here we have to pass this bracket ().
echo Today date is $DATE


#Arithmetic Substitution
ADD=$(( 2+2 ))     #Here we have to pass this two bracket ().
echo ADD of 2+2 = $ADD

#Access environment variable
echo Current User is - $USER
echo ENV Var test is - $test

#env=Is the command to list system variables.
#export abc=100  #To mark variable as a environment variables







