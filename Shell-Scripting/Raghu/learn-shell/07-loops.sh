# Two Basic Loops.
# For and While.


# For Loop -------------------------------
# Expression:
#for variable in list; do
    # Code to execute for each item in the list
#done

#Based on Inputs
for comp in frontend catalogue user ; do
  echo Installing Component - $comp
done

# Example using a sequence of numbers:
for i in {1..5}; do
    echo "Number: $i"
done


# While loop ---------------------------
#Expression
#while [ condition ]; do
    # Code to execute while the condition is true
#done
#Example to count down from 5:


count=5
while [ $count -gt 0 ]; do
    echo "Countdown: $count"
    count=$((count - 1))
done


# Based on Expression.
a=10
while [ $a -gt 0 ]; do
  echo Hello World
  a=$(($a-1))
  #break #This command can break the loop.
done

#This will print 10 times Hello World.


#until loop ----------------------------
#Expression:
#until [ condition ]; do
    # Code to execute until the condition is true
#done

#Example to count up until a condition is met:
count=1
until [ $count -ge 6 ]; do
    echo "Counting up: $count"
    count=$((count + 1))
done