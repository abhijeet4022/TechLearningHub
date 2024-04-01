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