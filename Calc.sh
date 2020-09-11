#!/bin/bash
ask_input (){
  is_num1=1
  is_num2=1
  both_num=1
  until [ "$both_num" = "0" ]
  do
    echo -e "\n\e[92mIngrese \"ans\" para utilizar el valor de la cuenta anterior\e[0m"
    echo -e "\n\e[96mElija el primer valor:\e[0m"
    read num1
    echo -e "\n\e[96mElija el segundo valor:\e[0m"
    read num2
    echo $num1 | egrep '^[Aa][Nn][Ss]$' &>/dev/null ; ans_num1=$?
    echo $num2 | egrep '^[Aa][Nn][Ss]$' &>/dev/null ; ans_num2=$?
    if [ $ans_num1 = "0" ]
    then
      num1=`cat ./memory.txt`
    elif [ $ans_num2 = "0" ]
    then
      num2=`cat ./memory.txt`
    fi
    echo $num1 | egrep '^[0-9]+$' &>/dev/null ; is_num1=$?
    echo $num2 | egrep '^[0-9]+$' &>/dev/null ; is_num2=$?
    if [ "$is_num1" = "0" -a "$is_num2" = "0" ]
    then
      both_num=0
    else
      echo -e "\n\e[31mSolo puede hacer operaciones entre numeros, por favor intente denuevo\e[0m"
    fi
  done
}
ans (){
  echo -e "\n\e[95mAns =\e[0m $result"
  echo $result > ./memory.txt
}
op=(
  "+ or suma"
  "- or dif"
  "* or mult"
  "/ or div"
  "% or resto"
  "** or exp"
  "q or exit"
  "Ans (ver ultimo resultado)"
)
input="Op"
until [ "$input" = "q" ]
do
    echo -e "\n\e[93mElija una operacion:\n!op para ver la lista de operaciones (\"q\" o \"exit\" para salir)\e[0m"
    read input
    echo $input | egrep '^[Aa][Nn][Ss]$' &>/dev/null ; mem=$?
    if [ "$mem" = "0" ]
    then
      result=`cat ./memory.txt`
      echo -e "\n\e[95mEl resultado anterior es:\e[0m $result"
    elif [ "$input" = "!op" ]
    then
      echo -e "\n\e[93mOperaciones validas:\e[0m"
      i=0
      until [ "$i" = "${#op[*]}" ]
      do
      echo -e "\e[94m${op[$i]}\e[0m"
      let i=$i+1
      done
    echo ""
  elif [ "$input" = "+" -o "$input" = "sum" ]
  then
    ask_input
    let result=$num1+$num2
    ans
  elif [ "$input" = "-" -o "$input" = "dif" ]
  then
    ask_input
    let result=$num1-$num2
    ans
  elif [ "$input" = "*" -o "$input" = "mult" ]
  then
    ask_input
    let result=$num1*$num2
    ans
  elif [ "$input" = "/" -o "$input" = "div" ]
  then
    ask_input
    let result=$num1/$num2
    ans
  elif [ "$input" = "%" -o "$input" = "resto" ]
  then
    ask_input
    let result=$num1%$num2
    ans
  elif [ "$input" = "**" -o "$input" = "exp" ]
  then
    ask_input
    let result=$num1**$num2
    ans
  elif [ "$input" = "q" -o "$input" = "exit" ]
  then
    echo -e "\n\e[31mCalculator closed\e[0m\n"
    exit 0
  else
    echo -e "\n\e[31mOperacion invalida\e[0m"
  fi
done
