#!/bin/bash

####
   # Marcelo Miranda 20200925  version 1.0
   # This is a a brute force script to recover a user password.
   # There were two motivations: 
   # 1. I lost the password for one user and I thought this to get it back; and
   # 2. to check the period of time to ṕass over all chars combinations
   #
   # initially the main motivation was this post:
   # https://www.hivesystems.io/blog/are-your-passwords-in-the-green
   # from which I became curious about its table image... I thought to check how 
   # many time would take on my raspberry (raspbian OS) to try all password 
   # combinations over a 92-chars base! For each try takes 3 seconds then...
   # ...it would take FIVE MILLIONS OF CENTURIES to break a 8-chars password!!!
   #
   # future improvements: 
   # . measuring effort  - for 1-char long, 2-, 3-, n- till success
   # . silent mode       - with no screen return till success 
   # . total silent more - with no logs or screen return till success
#### 

#### here is createad some arrays with chars password can have!
#------------------------ base of characters arrays ------------------------
declare -a numbers_array
declare -a alp_lower_array
declare -a alp_upper_array
declare -a basic_spec_array
declare -a chars_array

numbers_array=(0 1 2 3 4 5 6 7 8 9)
alp_lower_array=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
alp_upper_array=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
#### # ------- Problem: how to include the chars " (double quotes),
#### # * (asteristic) and ' (single quote, or "plic") in a chars array??
basic_spec_array=('!' '@' '#' '$' '%' '&' '_' '-' '=' '+' '(' '[' '{' '}' ']' ')' '~' '^' '`' '"' ',' '.' ';' ':' '<' '>' '/' '?' '|' '\')

#### 
   # some useful references will be informed as below...
   # merging arrays on an unique one
   # https://stackoverflow.com/questions/1986023/merging-two-arrays-in-bash
   # ...and concentrate ALL OF THEM in chars_array !
#### 

#chars_array=("${numbers_array[@]}")
chars_array=("${numbers_array[@]}" "${alp_lower_array[@]}" "${alp_upper_array[@]}" "${basic_spec_array[@]}")

#### chars_qtty keeps the quantity of chars (the numeric base) will be used
chars_qtty=${#chars_array[@]}  ### 92 characters till now...
#echo "chars_qtty: "${#chars_array[@]}" chars_array: "${chars_array[@]}

#### initializes useful variables
#------------------------ initialization ------------------------
generated_password=""
variant_char=""
check_return=""
counter=0  # starts = 0 # em 8464 deu erro >> 100(92)
divisor=$chars_qtty

#length=1
#converted=()

#### 
   # the main idea is to try strings from 1-char long till how many chars are
   # needed in password length to get success with su command for a user
   #
   # do you remember division nomenclature?
   # in Portuguese: https://brasilescola.uol.com.br/matematica/divisao.htm
   # in English:    https://en.wikipedia.org/wiki/Division_%28mathematics%29
   #
   # Any division operation has Dividend, Divisor, Quotient and Remainder.
   #         DIVIDEND  | DIVISOR
   #                   +----------
   #        REMAINDER    QUOTIENT
   #
   # Here is used the base-formation rule to generate the password string!
   #
   # For example: "5" in Decimal-Base (base 10) is represented by 
   #              "101" in Binary-base (base 2) or
   # ( 1 x2² )+( 0 x2¹ )+( 1 x2º ) = 1 x4 + 0 x2 + 1 x1 = 5 in decimal base.
   # ...then, number "101" in binary base (base 2) is "5" in decimal base (10).
   #
   # Some more examples below (between parentheses is the related base)
   # 000(2)=0(10), 001(2)=1(10), 010(2)=2(10), 011(2)=3(10), 100(2)=4(10)
   #
   # the COUNTER ordinal =>  DIVIDEND  | DIVISOR   <= BASE: chars_qtty 
   #                                   +----------
   #                        REMAINDER    QUOTIENT
####    
divisor=$chars_qtty

#echo "counter: "$counter
#while [ ${return:4:5} != 'Falha' ]

while [ $counter -lt 10000 ] ## 5132188731380000 for 92^8 combinations
do
  remainders=()
  dividend=$counter # 8460 ## 8556
  
  if [ $dividend -lt $divisor ]
  then
    let remainder=dividend%divisor
    remainders+=($remainder)
  fi    

  while [ $dividend -ge $divisor ] # dd=8460    # dd=92
  do
    let quotient=dividend/divisor  #  q=91      #  q=1    #  93=8556/92
    let remainder=dividend%divisor #  r=88      #  r=0    #  0

    remainders+=($remainder)       # Rs=( 88 )

#    echo "quotient: "$quotient" remainder: "$remainder" remainders: ( "${remainders[@]}" )"
 
    if [ $quotient -gt 0 ] && [ $quotient -lt $divisor ]
    then
      remainders+=($quotient)      # Rs=( 88 91 )
    fi

    dividend=$quotient
    
#    echo "counter: "$counter" dividend: "$dividend" quotient: "$quotient" remainder: "$remainder" remainders: ( "${remainders[@]}" )"

  done

  generated_password=""
  for (( i=1; i <= ${#remainders[@]}; i++ ))
  do 
    number=${remainders[`expr ${#remainders[@]} - $i`]}
    generated_password+=${chars_array[$number]}
#    echo "loop i:"$i" remainders["`expr $i - 1`"]="${remainders[$i - 1]}" number:"$number" generating password... >> "$generated_password" <<"
#    read -t 0.1 -p "0.1 sec... "
  done
#  echo "counter: "$counter" | generated password: "$generated_password" "
  echo "counter: "$counter" >> generated password: => "$generated_password" <="


#### test access with generated password
#### https://stackoverflow.com/questions/233217/how-to-pass-the-password-to-su-sudo-ssh-without-overriding-the-tty
  echo $generated_password | su test_acc
  # or try: su pi <<< generated_password

  # check if the access was succesfull
  ## return=`echo $?`
   # https://linuxhint.com/check_command_succeeded_bash/
  if [ $? -eq 0 ]; then
    echo "screen: OK for: "$generated_password
#### using '>>' redirects returns to display and files
#### - ref: https://stackoverflow.com/questions/14901373/how-do-i-log-output-of-a-shell-script-and-also-display-on-the-screen
    echo "log: OK for: "$generated_password >> returns.log
    break
#  else
#    echo "screen: FAIL for: "$generated_password
#    echo "log: FAIL for: "$generated_password >> returns.log
#    return = "su: Falha de autenticação"
  fi

  ((counter++))
#  echo "new counter: "$counter
done
duration=$SECONDS
echo "All done in "$duration" seconds."
# , or "$(($SECONDS/60))" minutes, or "$(($SECONDS/3600))" hours, or "$(($SECONDS/86400))" days."