#!/bin/bash
# Calculadora con memoria by Gone
clear
if [ ! -e ./memory.txt ]
then
  0 > ./memory.txt
fi

ans=`cat ./memory.txt`
input_number (){
  is_number=1
  until [ "$is_number" = "0" ]
  do
    echo -e "\n\e[96m$1\e[38;5;204m"
    read number
    if [ "$number" = "q" -o "$number" = "exit" ]
    then
      echo -e "\n\e[31mProgram was interrupted\e[0m"
      exit 1
    fi
    echo $number | egrep '^[Aa][Nn][Ss]$' &>/dev/null ; InputEqAns=$?
    if [ "$InputEqAns" = "0" ]
    then
      number=$ans
    fi
    is_number=`check_number $number`
    if [ ! "$is_number" = "0" ]
    then
      echo -e "\n\e[31mEsta calculadora utiliza unicamente numeros enteros, por favor intente denuevo\e[0m"
    fi
  done
}

check_number (){
  echo $1 | egrep '^[0-9]+$' &>/dev/null
  echo $?
}
ans (){
  echo -e "\n\e[95mAns:\e[0m $result"
  echo $result > ./memory.txt
}
op=(
  "+ or suma"
  "- or dif"
  "* or mult"
  "/ or div"
  "% or resto"
  "** or exp"
  "congruencias o cong"
  "q or exit"
  "Ans (ver ultimo resultado)"
)
input="Op"
until [ "$input" = "q" -o "$input" = "exit" ]
do
  echo -e "\n\e[38;5;208mElija una operacion:\n!op para ver la lista de operaciones (\"q\" o \"exit\" para salir en cualquier momento)\e[0m"
  echo -e "\e[92mIngrese \"ans\" para utilizar el valor de la cuenta anterior en todas las operaciones ( Ans = \"$ans\" )\e[0m\n\e[38;5;208mop:\e[38;5;204m"
  read input
  echo $input | egrep '^[Aa][Nn][Ss]$' &>/dev/null ; mem=$?
  if [ "$mem" = "0" ]
  then
    echo -e "\n\e[95mEl resultado anterior es:\e[0m $ans"
  elif [ "$input" = "!op" ]
  then
    echo -e "\n\e[38;5;208mOperaciones validas:\e[0m"
    i=0
    until [ "$i" = "${#op[*]}" ]
      do
      echo -e "\e[94m${op[$i]}\e[0m"
      let i=$i+1
      done
  elif [ "$input" = "+" -o "$input" = "sum" ]
  then
    input_number "Primer numero:"
    num1=$number
    input_number "Segundo numero:"
    num2=$number
    let result=$num1+$num2
    ans
  elif [ "$input" = "-" -o "$input" = "dif" ]
  then
    input_number "Primer numero:"
    num1=$number
    input_number "Segundo numero:"
    num2=$number
    let result=$num1-$num2
    ans
  elif [ "$input" = "*" -o "$input" = "mult" ]
  then
    input_number "Primer factor:"
    num1=$number
    input_number "Segundo factor:"
    num2=$number
    let result=$num1*$num2
    ans
  elif [ "$input" = "/" -o "$input" = "div" ]
  then
    input_number "Dividendo:"
    num1=$number
    input_number "Divisor:"
    num2=$number
    let result=$num1/$num2
    ans
  elif [ "$input" = "%" -o "$input" = "resto" ]
  then
    input_number "Dividendo:"
    num1=$number
    input_number "Divisor:"
    num2=$number
    let result=$num1%$num2
    ans
  elif [ "$input" = "**" -o "$input" = "exp" ]
  then
    input_number "Base:"
    num1=$number
    input_number "Exponente:"
    num2=$number
    let result=$num1**$num2
    ans
  elif [ "$input" = "congruencias" -o "$input" = "cong" ]
  then
    echo -e "\n\e[92mEsta operacion calcula los posibles valores de x con x cong. c(b) hasta d"
    input_number "Ingrese c:"
    c=$number
    input_number "Ingrese b:"
    b=$number
    input_number "Ingrese d:"
    d=$number
    echo -e "\n\e[95mResultados:\e[0m"
    x=0
    multiplo=0
    until [ $x -gt $d ]
    do
      let multiplo2=$b*$multiplo
      let x=$c+$multiplo2
      echo $x
      let multiplo=$multiplo+1
      let x=$x+$b
    done
  elif [ "$input" = "q" -o "$input" = "exit" ]
  then
    echo -e "\n\e[31mCalculator closed\e[0m\n"
    exit 0
  else
    echo -e "\n\e[31mOperacion invalida\e[0m"
  fi
done
