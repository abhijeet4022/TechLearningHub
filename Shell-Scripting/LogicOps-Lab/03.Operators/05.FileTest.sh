#!/bin/bash

FileName="04.Bitwise.sh"

if [ -e $FileName ]
then
	echo "Yes! The file exists"
else
	echo "No! The file doesn't exist"
fi

if [ -s $FileName ]
then
	echo "File is not empty."
else
	echo "File is empty."
fi

if [ -r $FileName ]
then
	echo "File has read access."
else
	echo "File does not has read access."
fi

# Not working as expected
if [ -w $FileName ]
then
	echo "The file has write access."
else
	echo "The file does not has write access."
fi

# Not working as expected
if [ -x $FileName ]
then
	echo "The file has execute access."
else
	echo "The file doesn't has execute access."
fi

if [ -k $FileName ]
then
	echo "The file has sticky bit permission."
else
	echo "The file doesn't has sticky bit permission."
fi

if [ -u $FileName ]
then
	echo "The file has SUID permission."
else
	echo "The file doesn't has SUID permission."
fi

if [ -g $FileName ]
then
	echo "The file has SGID permission."
else
	echo "The file doesn't has SGID permission."
fi
