#!/bin/bash

# Códigos de colores para la salida de la terminal.
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Función para cancelar la ejecución del programa
function ctrl_c(){
  echo -e "\n${redColour}[!] Saliendo...${endColour}"
  tput cnorm; exit 1
}

#Función para el CTRL+C
trap ctrl_c INT

#Creación del menú de opciones del comando
declare -i option_parameter=0 #Parámetro que tomará un valor según la opción que se indique desde la terminal

while getopts "sphf:k:" arg; do
  case $arg in
    s) let option_parameter+=1;; #Mostrar los recursos del sistema utilizándose 
    p) let option_parameter+=2;; #Mostrar los procesos del sistema
    f) process_name="$OPTARG"; let option_parameter+=3;; #Buscar un proceso
    k) process_id="$OPTARG"; let option_parameter+=4;; #Matar un proceso
    h) ;; #Panel de ayuda
  esac
done

if [ "$option_parameter" -eq 1 ];then
  echo "Opción s"
elif [ "$option_parameter" -eq 2 ];then
  echo "Opción p"
elif [ "$option_parameter" -eq 3 ];then
  echo "Opción f"
elif [ "$option_parameter" -eq 4 ];then
  echo "Opción k"
else
  echo "Opción h"
fi
