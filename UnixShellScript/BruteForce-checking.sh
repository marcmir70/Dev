#!/bin/bash

#### Marcelo Miranda 20200917 version 0.x checking version
#### this is a try of a brute force script to recover pi user password

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
counter=8460  # starts = 0 # em 8464 deu erro >> 100(92)
divisor=$chars_qtty

echo "counter: "$counter
## while [ ${return:4:5} != 'Falha' ]
while [ $counter -lt 8468 ]
do
  remainders=()
  dividend=$counter              # 8556
  let quotient=dividend/divisor  # 93=8556/92
  let remainder=dividend%divisor # 0

#  echo "* dividend:"$dividend", divisor:"$divisor", quotient:"$quotient", remainder:"$remainder
#  read -t 0.05
###  if [ $quotient -eq 0 ]
###  then 
###    remainders+=($remainder)
###  fi
###  if [ $quotient -gt 0 ] || [ $quotient -lt $divisor ]
###  then
###    remainders+=($remainder)
###    remainders+=($quotient)
###  fi
  
  echo "counter:"$counter", dividend:"$dividend", divisor:"$divisor", quotient:"$quotient", remainder:"$remainder
###  checked=2
  
  divisible=1
  ### while [ $divisible -eq 1 ]
while [ $dividend -ge $divisor ] 
  do
    if [ $quotient -eq 0 ]
    then 
      checked=1
      remainders+=($remainder)
      divisible=0
      echo while-if1
    else # troquei o OU "||" por E "&&"
      if [ $quotient -gt 0 ] && [ $quotient -lt $divisor ]
      then
###        checked=1
        remainders+=($remainder)
        remainders+=($quotient)
        divisible=0
        echo while-if2
###      fi
###    fi
      else
###        if [ $quotient -gt $divisor ]
###        then
###          checked=1
###          remainders+=($remainder)
          dividend=$quotient
          echo while-else2
###        fi
      fi
    fi
    
###    if [ $quotient -eq $divisor ]
###    then
###      ((checked++))
###      remainders+=(0)
###      remainders+=(1)
###      echo while-if4
###    fi
    
    let quotient=dividend/divisor
    let remainder=dividend%divisor
    
    echo "quotient: "$quotient" remainder: "$remainder
    echo "divisible: "$divisible" remainders: ( "${remainders[@]}" )"
###    ((checked++)) 
###    if [ $checked -ge 4 ]
###    then
###        break
###    fi

# counter:8556, dividend:8556, divisor:92, quotient:93, remainder:0
# while-if2
# while-if3
# divisible: 0 remainders: >>0 93 0<< ERRO  =>  seria >>1 0 0<<
# generated password: >\\<
# ----------------------------- após trocar || por &&
# counter:8461, dividend:8461, divisor:92, quotient:91, remainder:89
# while-if2
# divisible: 0 remainders: >>89 91<<
# generated password: >|/<

# counter:8462, dividend:8462, divisor:92, quotient:91, remainder:90
# while-if2
# divisible: 0 remainders: >>90 91<<
# generated password: >|?<

# counter:8463, dividend:8463, divisor:92, quotient:91, remainder:91
# while-if2
# divisible: 0 remainders: >>91 91<<
# generated password: >||<

# counter:8464, dividend:8464, divisor:92, quotient:92, remainder:0
# divisible: 1 remainders: >><<
# divisible: 1 remainders: >><<
# divisible: 1 remainders: >><<

  done

##    echo "if: quotient:"$quotient" remainders: "${remainders[@]}
##  else
###    if [ $quotient -gt 0 ] || [ $quotient -lt $divisor ]
###    then
###      remainders+=($quotient)
###      echo "   if 2: quotient:"$quotient" remainders:"${remainders[@]}
###    else
###      while [ $quotient -ge $divisor ] 
###      do
###        remainders+=($remainder)
###        dividend=$quotient
###        let quotient=dividend/divisor
###        let remainder=dividend%divisor
###        echo "      while 2: dividend:"$dividend", divisor:"$divisor", quotient:"$quotient", remainder:"$remainder
####        read -t 0.2 -p ".2 sec.."
###      done
###    fi
#####  fi

  generated_password=""
#  if [ ${#remainders[@]} -eq 1 ]
#  then
#    number=${remainders[`expr ${#remainders[@]} - 1`]}
#    generated_password+=${chars_array[$number-1]}
#  else
    for (( i=1; i <= ${#remainders[@]}; i++ ))
    do 
      number=${remainders[`expr ${#remainders[@]} - $i`]}
      generated_password+=${chars_array[$number]}
      echo "loop i:"$i" remainders["`expr $i - 1`"]="${remainders[$i - 1]}" number:"$number" generating password... >> "$generated_password" <<"
#####      read -t 0.1 -p "0.1 sec... "
    done
#  fi
  echo "generated password: >"$generated_password"<"
#####  read -t .2 -p ".2 sec... "
  echo
#  echo

  ((counter++))
####  echo "new counter: "$counter
done
echo "All done"