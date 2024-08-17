# for and while is two basic loops in shell scripting.

# Based on expression

# While loop
a=10
while [ $a -gt 0 ]; do
    echo "Hello World"
    a=$(($a-1))
    #break : This will break the loop.
done

num=1
while [ $num -le 6 ]
do
	echo "Welcome $num times"
	((num++))
done


# For loops
for component in catalogue user cart ; do
  echo Installing the component - $component
done


