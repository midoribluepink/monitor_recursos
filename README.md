# Monitor de recursos

# ✅ Opciones
- s) Mostrar los recursos del sistema

  Esta opción mostrará el uso de CPU, RAM y los procesos totale del sistema.
  ```bash
  ./monitor_recursos.sh -s
  ```
  ![image](https://github.com/user-attachments/assets/7bca6495-babf-4e67-93e1-294568c82849)

- p) Mostrar los recursos del sistema

  Esta opción filtrará los procesos de mayor consumo. Es decir, aquellos con un consumo de CPU y/o RAM mayores al 1%.
  ```bash
  ./monitor_recursos.sh -p
  ```
  ![image](https://github.com/user-attachments/assets/cb071bf7-9cf3-4179-b81b-3fbbd204318d)

- f) Buscar un proceso

  Esta opción mostrará los procesos que coincidan con el parámetro dado.
  ```bash
  ./monitor_recursos.sh -f firefox
  ```
  ![image](https://github.com/user-attachments/assets/323ec1d6-7b24-4ba6-8d8b-93f017a5d137)

- k) Matar un procesos

  Esta opción matará el proceso con el PID dado.
  ```bash
  ./monitor_recursos -k 123456
  ```
  ![image](https://github.com/user-attachments/assets/e07b1b31-5a4c-45d8-9a51-27e0f6c89cf1)

  O de forma forzada:
  ```bash
  ./monitor_recursos -k 123456 -a
  ```
  ![image](https://github.com/user-attachments/assets/d0bb6224-601e-4a9b-a089-697cd44a040b)


  
