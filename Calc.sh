#!/bin/bash
# Calculadora con memoria by Gone
clear
if [ ! -e ./memory.txt ]
then
  0 > ./memory.txt
fi

ans=`cat ./memory.txt`
input_number (){
  ans=`cat ./memory.txt`
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
      echo -e "\n\e[31mEsta calculadora utiliza unicamente numeros naturales y 0, por favor intente denuevo\e[0m"
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
  ans=`cat ./memory.txt`
}
op=(
  "+ or suma"
  "- or dif"
  "* or mult"
  "/ or div"
  "% or resto"
  "** or exp"
  "congruencias o cong"
  "chkcong"
  "q or exit"
  "Ans (ver ultimo resultado)"
  "TCR"
)
input="Op"
until [ "$input" = "q" -o "$input" = "exit" ]
do
  echo -e "\n\e[38;5;208mElija una operacion:\n!op para ver la lista de operaciones (\"q\" o \"exit\" para salir en cualquier momento)\e[0m"
  echo -e "\e[92mIngrese \"ans\" para utilizar el valor de la cuenta anterior en todas las operaciones (\e[95m Ans = \"$ans\"\e[92m )\e[0m\n\e[38;5;208mop:\e[38;5;204m"
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
    if [ -e ./listacongruencia.txt ]
    then
      rm ./listacongruencia.txt
    fi
    until [ $x -gt $d ]
    do
      let multiplo2=$b*$multiplo
      let x=$c+$multiplo2
      echo $x >> ./listacongruencia.txt
      let multiplo=$multiplo+1
      let x=$x+$b
    done
    cat ./listacongruencia.txt
  elif [ "$input" = "chkcong" ]
  then
    echo -e "\n\e[92mEsta operacion chequea los restos de todos los x modulo (b)"
    input_number "Ingrese b:"
    b=$number
    echo ""
    for x in `cat ./listacongruencia.txt`
    do
      let resto=$x%$b
      echo -e "\e[95mEl resto de dividir \e[92m$x\e[95m por \e[92m$b\e[95m es = \e[0m$resto"
    done
  elif [ "$input" = "TCR" ]
  then
    echo -e "\e[92mEsta operacion resuelve sistemas de congruencia (\e[38;5;208m PUEDE TARDAR MUCHO TIEMPO PARA NUMEROS GRANDES\e[92m )"
    input_number "Cuantas ecuaciones tiene el sistema?"
    opnum=$number
    a=0
    input_number "Cual es el multiplo de los modulos? ej b1*b2*b3"
    d=$number
    until [ $a -eq $opnum ]
    do
      input_number "Ingrese c$a:"
      c=$number
      input_number "Ingrese b$a:"
      b=$number
      x=0
      multiplo=0
      until [ $x -gt $d ]
      do
        let multiplo2=$b*$multiplo
        let x=$c+$multiplo2
        echo $x >> ./TCR$a.txt
        let multiplo=$multiplo+1
        let x=$x+$b
      done
      let a=$a+1
    done
    cat ./TCR0.txt > ./knownmatches.txt
    echo -e "\n\e[90mProcesando..."
    w=1
    r=0
    until [ $w -eq $opnum ]
    do
      for i in `cat ./TCR$w.txt`
      do
        cat ./knownmatches.txt | egrep "^$i\$" &>/dev/null
        if [ $? -eq 0 ]
        then
          echo $i >> ./tempmatches.txt
        fi
      done
      rm ./knownmatches.txt
      if [ -e ./tempmatches.txt ]
      then
        cat ./tempmatches.txt > ./knownmatches.txt
        rm ./tempmatches.txt
        let w=$w+1
      else
        echo "No hay soluciones al sistema" > ./error.txt
        nope=`cat ./error.txt`
        let w=$opnum
      fi
    done
    for i in `ls ./TCR*.txt`
    do
      rm $i
    done
    echo -e "\n\e[95mSoluciones del sistema:\n"
    if [ -e ./error.txt ]
    then
      echo -e "\e[31m$nope"
      rm ./error.txt
    else
      cat ./knownmatches.txt > ./listacongruencia.txt
      p=1
      for i in `cat ./knownmatches.txt`
      do
        echo -e "\e[m$p) \e[92mx\e[95m cong. \e[92m$i\e[95m(\e[92m$d\e[95m)"
        let p=$p+1
      done
    fi
    if [ -e ./knownmatches.txt ]
    then
      rm ./knownmatches.txt
    fi
  elif [ "$input" = "q" -o "$input" = "exit" ]
  then
    echo -e "\n\e[31mCalculator closed\e[0m\n"
    exit 0
  else
    echo -e "\n\e[31mOperacion invalida\e[0m"
  fi
done
