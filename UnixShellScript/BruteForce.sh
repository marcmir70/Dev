#!/bin/bash

#### Marcelo Miranda 20200917 version 1
#### this is a try of a brute force script to recover pi user password


#### here is createad some arrays with chars password can have!
#------------------------ base of characters arrays ------------------------
declare -a alp_lower_array
declare -a alp_upper_array
declare -a numbers_array
declare -a basic_spec_array
declare -a chars_array

alp_lower_array=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
alp_upper_array=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
numbers_array=(1 2 3 4 5 6 7 8 9 0)
#### # ------- Problem: how to include the chars " (double quotes),
#### # * (asteristic) and ' (single quote, or "plic") in a chars array??
basic_spec_array=('!' '@' '#' '$' '%' '&' '_' '-' '=' '+' '(' '[' '{' '}' ']' ')' '~' '^' '`' '"' ',' '.' ';' ':' '<' '>' '/' '?' '|' '\')


#### some useful references will be informed as below...
# merging arrays on an unique one
 # https://stackoverflow.com/questions/1986023/merging-two-arrays-in-bash


#### ...and concentrate ALL OF THEM in chars_array !
chars_array=("${alp_lower_array[@]}" "${alp_upper_array[@]}" "${numbers_array[@]}" "${basic_spec_array[@]}")

#### chars_qtty keeps the quantity of chars will be used
chars_qtty=${#chars_array[@]}  ### 92 characters till now...


#### initializes useful variables
#------------------------ initialization ------------------------
## echo $var_pass
# error >> su: Falha de autenticação

generated_password=""
variant_char=""
check_return=""
counter=1
length=1
converted=()

#### the main idea is to try string passwords formed from 1-char long 
#### till how many chars in password length are needed till get success
#### with su command for pi user

#### do you remember division nomenclature? In Portuguese, below
  # reminder: https://brasilescola.uol.com.br/matematica/divisao.htm
  # in English: https://en.wikipedia.org/wiki/Division_%28mathematics%29
#### division has Dividen, Divisor, Quotient and Remainder, as below
#### 
#### Here is used the base-formation rule to generate the string!
####   For example: 5 in Binary-base (base 2) is represented by 101 or
#### ( 1x2² )+( 0x2¹ )+( 1x2º ) = 1x4 + 0x2 + 1x1 = 5 in decimal base.
#### ...then, number "101" in binary base is "5" in base 10.
####
#### Some more examples below (between parentheses is the related base)
#### 000(2)=0(10), 001(2)=1(10), 010(2)=2(10), 011(2)=3(10), 100(2)=4(10)
####
#### the COUNTER ordinal =>  DIVIDEND  | DIVISOR   <= BASE: chars_qtty 
####                                   +----------
####                        REMAINDER    QUOTIENT
divisor=chars_qtty

while [ ${return:4:5} != 'Falha' ]
do
  remainders=()
  based_conv_num=()  ### ???
  dividend=counter
  quotient=dividend / divisor
  remainder=dividend % divisor

  while [ quotient > divisor ] 
  do
    remainders+=($remainder)
    dividend=quotient
    quotient=dividend / divisor
    remainder=dividend % divisor
  done

  generated_password=""
  for (( i=1; i <= ${#restos[@]}; i++ )); 
  do 
    restos_number=${restos[`expr ${#restos[@]} - $i`]}
    generated_password+=${chars_array[$restos_number]}
  done

###  for variant_char in "${chars_array[@]}"  ## pass through all array elements...
##  do 

#### generate password with <length> of characters
###   for variant_char in "${chars_array[@]}"  ## pass through all array elements...
###   do 
###      generated_password=$base_password$variant_char

      # test access with generated password
       # https://stackoverflow.com/questions/233217/how-to-pass-the-password-to-su-sudo-ssh-without-overriding-the-tty
      echo generated_password | su pi
       # or try: su pi <<< var_password

      # check if the access was succesfull
       ## return=`echo $?`
       # https://linuxhint.com/check_command_succeeded_bash/
      if [ $? -eq 0 ]; then
        echo "screen: OK for: "$var_password
        # using '>>' redirects returns to display and files
         # - ref: https://stackoverflow.com/questions/14901373/how-do-i-log-output-of-a-shell-script-and-also-display-on-the-screen
        echo "log: OK for: "$var_password >> returns.log
        break
      else
        echo "screen: FAIL for: "$var_password
        echo "log: FAIL for: "$var_password >> returns.log
        return = "su: Falha de autenticação"
      fi

      echo $counter
      ((counter++))
    done
  base_password=
  done
done
echo "All done"


## var="Memory Used: 19.54M"
## result=`echo "$var" | awk -F'[M ]' '{print $4}'`

## ${var#*: }