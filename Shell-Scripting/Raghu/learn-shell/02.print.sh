# To print any line
echo HelloWorld

# If we have any extra character then use "".
echo "<<<<<<<< Hello  World >>>>>>>"

# Print colour
# Red - 31
# Green - 32
# Yellow - 33
# Blue - 34
# Magenta - 35
# Cyan - 36
# echo -e "\e[CODEmMESSAGE\e[0m"
# 0m is used to disable/reset the colour.

echo -e "\e[31mHello World\e[0m"
echo -e "\e[32mHello World\e[0m"
echo -e "\e[33mHello World\e[0m"
echo -e "\e[34mHello World\e[0m"
echo -e "\e[35mHello World\e[0m"
echo -e "\e[36mHello World\e[0m"

# Quote

# It will give unexpected output.
echo ** Hello **

# Now use "".
echo '** Hello **'

# there is a diff between single quote and double quote let's try.

a=10
echo "Value of a = $a"
echo 'Value of a = $a'

# In single quote whole it will consider as text only and it wont give output for $a.
# But where as we will get this for double quote.

# Redirect the stdout and stderr to diff diff file.
ls non_existent_directory > output.txt 2> error.txt

# Redirect the stdout and stderr to same file.
ls non_existent_directory &> error_output.txt

# It will prnit the output and redirect the output in /tmp/roboshop.log
echo -e "\e[34mConfiguring the repo for NodeJS.\e\n[0m" | tee -a /tmp/roboshop.log
#\n to change the line


