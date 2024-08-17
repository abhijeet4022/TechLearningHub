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







