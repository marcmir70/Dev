#!/bin/bash

#### Marcelo Miranda 20200924 checking version 1.0
#### this is a try of a brute force script to recover a user password
#### there were two motivations: 
#### 1. I lost the password for one user and I thought this to get it back; and
#### 2. to check the period of time to ṕass over all chars combinations

SECONDS=0
#------------------------ base of characters arrays ------------------------
declare -a alp_lower_array
declare -a alp_upper_array
declare -a numbers_array
declare -a basic_spec_array
declare -a chars_array

numbers_array=(0 1 2 3 4 5 6 7 8 9)
alp_lower_array=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
alp_upper_array=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
#### # ------- Problem: how to include the chars " (double quotes),
#### # * (asteristic) and ' (single quote, or "plic") in a chars array??
basic_spec_array=('!' '@' '#' '$' '%' '&' '_' '-' '=' '+' '(' '[' '{' '}' ']' ')' '~' '^' '`' '"' ',' '.' ';' ':' '<' '>' '/' '?' '|' '\')
chars_array=("${numbers_array[@]}" "${alp_lower_array[@]}" "${alp_upper_array[@]}" "${basic_spec_array[@]}")
echo "chars_array: "${chars_array[@]}
chars_qtty=${#chars_array[@]}  ### 92 characters till now...
echo "chars_qtty: "${#chars_array[@]}

#### initializes useful variables
#------------------------ initialization ------------------------
## echo $var_pass
# error >> su: Falha de autenticação

generated_password=""
variant_char=""
check_return=""
counter=0  # starts = 0 # em 8464 deu erro >> 100(92)
divisor=$chars_qtty

# echo "counter: "$counter
## while [ ${return:4:5} != 'Falha' ]
while [ $counter -lt 10000 ] ## 5132188731380000ls 
do
  remainders=()
  dividend=$counter # 8460 ## 8556
  
  if [ $dividend -lt $divisor ]
  then
    let remainder=dividend%divisor
    remainders+=($remainder)
  fi    

  while [ $dividend -ge $divisor ] # dd=8460 # dd=92 ### $divisible -eq 1 ]
  do
    let quotient=dividend/divisor  #  q=91   #  q=1  ## 93=8556/92
    let remainder=dividend%divisor #  r=88   #  r=0  ## 0

    remainders+=($remainder)  # Rs=( 88 )

##    echo "quotient: "$quotient" remainder: "$remainder" remainders: ( "${remainders[@]}" )"
 
    if [ $quotient -gt 0 ] && [ $quotient -lt $divisor ]
    then
      remainders+=($quotient)  # Rs=( 88 91 )
    fi

##    if [ $quotient -ge $divisor ]
##    then
    dividend=$quotient
##    fi
    
##    echo "counter: "$counter" dividend: "$dividend" quotient: "$quotient" remainder: "$remainder" remainders: ( "${remainders[@]}" )"

  done

  generated_password=""
    for (( i=1; i <= ${#remainders[@]}; i++ ))
    do 
      number=${remainders[`expr ${#remainders[@]} - $i`]}
      generated_password+=${chars_array[$number]}
##      echo "loop i:"$i" remainders["`expr $i - 1`"]="${remainders[$i - 1]}" number:"$number" generating password... >> "$generated_password" <<"
##      read -t 0.1 -p "0.1 sec... "
    done
#  echo "counter: "$counter" | generated password: "$generated_password" "
  echo $generated_password" "

  ((counter++))
####  echo "new counter: "$counter
done
duration=$SECONDS
echo "All done in "$duration" seconds."
## , or "$(($SECONDS/60))" minutes, or "$(($SECONDS/3600))" hours, or "$(($SECONDS/86400))" days."