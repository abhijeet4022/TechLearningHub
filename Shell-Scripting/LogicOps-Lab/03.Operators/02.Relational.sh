#!/bin/bash

a=10
b=20

if(( $a==$b ))
then
	echo "a is equal to b."
else
	echo "a is not equal to b."
fi

if(( $a!=$b ))
then
	echo "a is not equal to b."
else
	echo "a is equal to b."
fi

if(( $a<$b ))
then
	echo "a is less than b."
else
	echo "a is not less than b."
fi

#if(( $a<=$b ))
if [ $a -ge $b ]
then
	echo -e "\e[33ma is less than or equal to b.\e[0m\n"
else
	echo -e "\e[33ma is not less than or equal to b.\e[0m\n"
fi

if(( $a>$b ))
then
	echo "a is greater than b."
else
	echo "a is not greater than b."
fi

if (($a>=$b))
then
	echo "a is greater than or equal to b."
else
	echo "a is not greater than or equal to b."
fi
