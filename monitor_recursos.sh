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

#Función para el panel de ayuda
function helpPanel(){
  echo -e "\n${grayColour}Uso: ${endColour}"
  echo -e "\t${purpleColour}s)${endColour} ${grayColour} Mostrar los recursos del sistema${endColour}"
  echo -e "\t${purpleColour}p)${endColour} ${grayColour} Mostrar los procesos del sistema${endColour}"
  echo -e "\t${purpleColour}f)${endColour} ${grayColour} Buscar un proceso específico${endColour}"
  echo -e "\t${purpleColour}k)${endColour} ${grayColour} Matar un proceso (Insertar PID)${endColour}"
  echo -e "\t${purpleColour}h)${endColour} ${grayColour} Mostar el panel de ayuda${endColour}"
}

#Función para mostrar los recursos del sistema
function showStats(){
  cpu_user=$(top -bn 1 | grep "%Cpu" | awk '{print $2}') #Obtenemos el porcentaje de CPU utilizado por el usuario
  cpu_sys=$(top -bn 1 | grep "%Cpu" | awk '{print $4}') #Obtenemos el porcentaje de CPU utilizado por el sistema
  cpu_total=$(echo "$cpu_user + $cpu_sys" | bc) #Sumamos los porcentajes anteriores para obtener el total

  total_memory=$(top -bn 1 | grep "Mem :" | awk '{print $4}') #Obtenemos la memoria total del sistema
  used_memory=$(top -bn 1 | grep "Mem :" | awk '{print $8}') #Obtenemos la memoria utilizada
  buffer_memory=$(top -bn 1 | grep "Mem :" | awk '{print $10}') #Obtenemos la memoria del buffer
  total_used_memory=$(echo "$used_memory + $buffer_memory" | bc) #Calculamos la cantidad de memoria total utilizada 

  percentage_memory=$(echo "$total_used_memory*100/$total_memory" | bc) #Calculamos el porcentaje de memoria total utilizada

  total_jobs=$(top -bn 1 | awk 'NR == 2' | awk '{print $2}') #Obtenemos la cantidad de procesos del sistema
  
  #Imprimimos los resultados
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Recursos del sistema:${endColour}"
  echo -e "\n${greenColour}CPU:${endColour} ${purpleColour}$cpu_total%${endColour} ${blueColour}|${endColour} ${greenColour}RAM:${endColour} ${purpleColour}$percentage_memory%${endColour} ${blueColour}|${endColour} ${greenColour}Procesos:${endColour} ${purpleColour}$total_jobs${endColour}"

}

#Función para mostrar los procesos
function showJobs(){
  # Imprimir en pantalla los recursos que vamos a listar
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Procesos con consumo de${endColour} ${purpleColour}CPU${endColour} ${grayColour}y${endColour} ${purpleColour}RAM${endColour} ${grayColour}mayores al ${endColour}${greenColour}1%${endColour}${endColour}\n"
  echo -e "${yellowColour}PID${endColour}\t\t${greenColour}CPU Usage(%)${endColour}\t${purpleColour}RAM Usage(%)${endColour}\t${redColour}Process Name${endColour}"
  top -bn 1 | tail -n +8 | while IFS= read -r linea; do #Leemos línea por línea del comando top
  cpu_usage=$(echo $linea | awk '{print $9}') #Uso de CPU de cada proceso
  ram_usage=$(echo $linea | awk '{print $10}') #Uso de RAM de cada proceso
  pid_number=$(echo $linea | awk '{print $1}') #PID de cada proceso
  process_name=$(echo $linea | awk 'NF{print $NF}') #Nombre de cada proceso
  #Condicional que solo se ejecuta cuando el uso de cpu o de ram del proceso por el que se itera es mayor al 1%
  if [ "$(echo "$cpu_usage > 1" | bc)" -eq 1 ] || [ "$(echo "$ram_usage > 1" | bc)" -eq 1 ]; then 
    #Imprimimos los recursos utilizados
    echo -e "${yellowColour}$pid_number${endColour}\t\t${greenColour}$cpu_usage${endColour}\t\t${purpleColour}$ram_usage${endColour}\t\t${redColour}$process_name${endColour}"
  fi
done
}

function searchJobs(){
  #Función para buscar procesos
  process_name="$1"
  
  #Comprobamos si el proceso existe en ejecución
  process_checker=$(top -bn 1 | tail -n +8 | grep -i "$process_name")
  if [ "$process_checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Se ha encontrado el siguiente proceso:${endColour}"
    echo -e "${yellowColour}PID${endColour}\t\t${greenColour}CPU Usage(%)${endColour}\t${purpleColour}RAM Usage(%)${endColour}\t${redColour}Process Name${endColour}\t${blueColour}User${endColour}"

    #Si el proceso existe, se itera entre los posibles procesos con el mismo nombre
    top -bn 1 | tail -n +8 | grep -i "$process_name" | while IFS= read -r linea; do 
    cpu_usage=$(echo $linea | grep -i "$process_name" | awk '{print $9}') #Uso de CPU de cada proceso
    ram_usage=$(echo $linea | grep -i "$process_name" | awk '{print $10}') #Uso de RAM de cada proceso
    pid_number=$(echo $linea | grep -i "$process_name" | awk '{print $1}') #PID de cada proceso
    job_name=$(echo $linea | grep -i "$process_name" | awk 'NF{print $NF}' | sed 's/\+//') #PID de cada proceso
    process_user=$(echo $linea | grep -i "$process_name" | awk '{print $2}') #Nombre del usuario del proceso
    
    echo -e "${yellowColour}$pid_number${endColour}\t\t${greenColour}$cpu_usage${endColour}\t\t${purpleColour}$ram_usage${endColour}\t\t${redColour}$job_name${endColour}\t\t${blueColour}$process_user${endColour}"
    done
  else
    echo -e "\n${redColour}[!] El proceso no existe${endColour}"
  fi

}

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
  showStats
elif [ "$option_parameter" -eq 2 ];then
  showJobs
elif [ "$option_parameter" -eq 3 ];then
  searchJobs $process_name
elif [ "$option_parameter" -eq 4 ];then
  echo "Opción k"
else
  helpPanel
fi
