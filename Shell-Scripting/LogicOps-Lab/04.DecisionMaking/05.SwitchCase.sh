#!/bin/bash

DOGS="scoobydoo"

#Pass the variable in string

case "$DOGS" in
	#case 1
	"indie") echo "Found in moderate temperature places" ;;
	
	#case 2
	"scoobydoo") mkdir /root/test ;;
	
	#case 3
	"husky") echo "Found in very cold places" ;;
esac
