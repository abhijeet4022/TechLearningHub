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

echo -e "\e[31m Hello World \e[0m"

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


