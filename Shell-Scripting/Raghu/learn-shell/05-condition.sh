a=10
if [ $a -gt 0 ]; then
  echo $a is greater then zero
fi

age=18
if [ $age -ge 18 ]; then
    echo "You are an adult."
fi


#if-else expression
# Example:

if [ $age -ge 18 ]; then
    echo "You are an adult."
else
    echo "You are not an adult."
fi


# if-elif-else Statement:
#Example:
if [ $age -lt 13 ]; then
    echo "You are a child."
elif [ $age -ge 13 ] && [ $age -lt 18 ]; then
    echo "You are a teenager."
else
    echo "You are an adult."
fi