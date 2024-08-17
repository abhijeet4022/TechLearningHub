#!/bin/bash

echo -e -n  "\n\e[33mPlease enter your desired number: \e[0m"
read NUM

case $NUM in
        2)
          echo -e "\n\e[32mYour Entered number is $NUM\n\e[0m"
        ;;
        3 | 4 | 5)
          echo -e "\n\e[32mYour Entered number is $NUM\n\e[0m"
        ;;
        *)
          echo -e "\n\e[31mYour Entered number is OOC\n\e[0m"
        ;;
esac
