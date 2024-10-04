# Function declaration.
greeting() {
  echo Hello, Good Morning!
  echo Welcome to Devops Training
  echo Good to have you hear
}

# By using the greeting function we can print all three line.
greeting


# Exit will  come out from the script
greeting() {
  echo Hello, Good Morning!
  echo Welcome to Devops Training
  exit
  echo Good to have you hear
}
# By using the greeting function we can print all three line.
greeting

echo Function exit status is - $?


# Return will  come out from the function
greeting() {
  echo Hello, Good Morning!
  echo Welcome to Devops Training
  return
  echo Good to have you hear
}

# By using the greeting function we can print all three line.
greeting
echo Function exit status is - $?

# You declare var in main program, you can access that in function and vice-versa.
# Function have its own special variables.

greeting() {
echo -e "Hello, Good Morning.\n"
echo -e "Welcome to DevOps Training.\n"
echo -e "Good to Have you here.\n"
}

# So by using function we can pass multiple command in a single.
# here greeting will give the output of mentioned three echo command.
greeting
echo function exit status - $?

#exit: If we want to come out-from script we will pass exit
#return : if we want to exit from function then we will pass return

# We declare var in main program, we can access that in function and vice-versa.
# Function have its own special variables.

input(){
  echo First Argument - $1
  echo Senond Argument - $2
  echo All Arguments - $*
  echo No of Arguments - $#
}

input abc 1234