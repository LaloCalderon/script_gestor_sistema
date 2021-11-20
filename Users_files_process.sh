#!/bin/bash
OPC=0
while [ "$OPC" != 5 ]
do
echo "Ingresa una opción"

echo "1) Manejo de archivos"
echo "2) Manejo de procesos"
echo "3) Monitore de usuarios"
echo "4) Información del sistema"
echo "5) Salir"

read -p "-->" OPC
case $OPC in

     1)
     echo "Seleccionó Manejo de archivos"
     busqueda=0
     while [ "$busqueda" != 3 ]
     do
       echo "¿Cómo deseas hacer la búsqueda? :"
       echo "1) Todo el sistema"
       echo "2) Directorio Actual"
       echo "3) Regresar al menú principal "
       read -p "-->" busqueda
       case $busqueda in
 
         1)
           echo "Introduce el nombre del archivo a buscar: "
           read -p "->" fichero
           num=0
           find / -type b,c,d,p,f,l,s -name $fichero > salida 2>errores.log
           num=$(cat salida | wc -l)
           if test ! -s salida
           then
	     echo "no existen archivos con el nombre: $fichero"
            
             while [ "$opcion_sec" != 2 ]
             do
               echo "Ingresa una opción: "
               echo "1) Buscar otro archivo"
               echo "2) Regresar al menú principal"
               read -p "->" opcion_sec
               case $opcion_sec in
               1)
                 echo " "
                 opcion_sec=2
               ;;
               2)
                 echo "Regreso al menú anterior: "
                 opcion_sec=2
                 busqueda=3
               ;;
               *)
                 echo "opción inválida"
               ;;
               esac
             done 
             
           else
  	     echo "existen $num ficheros con el nombre: $fichero"
           fi
         ;;
         2)
           echo "Ingresa el nombre del archivo a buscar en el directorio actual: "
           read local_file 
           responde=$(ls -la $local_file 2>errores.log) #si Responde:
           if [ -n "$responde" ]
           then
             echo "Nombre del archivo: $local_file"
             echo "Número de i-nodo: "
             ls -li $local_file | awk '{$1=$1}1' OFS="/" | cut -f 1 -d/
             echo "Tipo de archivo: "
             ls -la $local_file | cut -c 1

             echo "Número de ligas duras: "
             ls -la $local_file | awk '{$1=$1}1' OFS="," | cut -f 2 -d, 

             echo "Dueño: "
             ls -la $local_file | awk '{$1=$1}1' OFS="," | cut -f 3 -d,
             
             echo "Grupo: "
             ls -la $local_file | awk '{$1=$1}1' OFS="," | cut -f 4 -d,
             echo "Tamaño en bytes: "
             ls -la $local_file | awk '{$1=$1}1' OFS="," | cut -f 5 -d,
    
             echo "Último acceso: "
             ls -lu $local_file | awk '{$1=$1}1' OFS="/" | cut -f 6-8 -d/
             echo "Última modificación: "
             ls -la $local_file | awk '{$1=$1}1' OFS="/" | cut -f 6-8 -d/
             echo "Última modificación del i-nodo: "
             ls -lc $local_file | awk '{$1=$1}1' OFS="/" | cut -f 6-8 -d/
             echo "Permisos del usuario: "
             ls -la $local_file | cut -c 2,3,4
             echo "Permsos del grupo: "
             ls -la $local_file | cut -c 5,6,7
             echo "Permisos de los otros: "
             ls -la $local_file | cut -c 8,9,10
             
             opcion=0
             while [ "$opcion" != 3 ]
             do
               echo "Ingresa una opción para trabajar con el archivo:"
               echo "1) Modificar permisos (modo octal)"
               echo "2) Borrar el archivo"
               echo "3) Regresar al menú principal"
               read opcion
               case $opcion in
	         1)
	           echo "Ingresa los permisos que deseas colocar: "
                   read permisos
                   case ${permisos#[+-]} in
                     *[!0-9]* ) echo "Ingresa una cadena numérica válida"  ;;
                     * )  chmod $permisos $local_file 2>errores.log
                          echo "Los permisos se cambiaron"  ;;
                   esac
	         ;;
                   
	         2)
                   rm $local_file 2>errores.log
	           echo "El archivo de eliminó de forma correcta"
                   opcion=3
                  
	         ;;

	         3)
	           echo "Regresa al menú principal"
		   opcion=3
                   busqueda=3
	         ;;

	         *)
	           echo "Opción inválida"
	         ;;

                 esac
             done
           else
            echo "No hay coincidencias"
            
            while [ "$opcion_sec" != 2 ]
            do
              echo "Ingresa una opción: "
              echo "1) Buscar otro archivo"
              echo "2) Regresar al menú principal"
              read -p "->" opcion_sec
              case $opcion_sec in
               1)
                 echo " "
                 opcion_sec=2
               ;;
               2)
                 echo "Regreso al menú principal: "
                 opcion_sec=2
                 busqueda=3
               ;;
               *)
                 echo "opción inválida"
               ;;
              esac
            done 

           fi
         ;;
         3)
           echo "==Regresó al menú principal=="
           busqueda=3
         ;;
         *)
           echo "Opción-Inválida"
         ;;
         esac    #Fin del caso menú selección de búsqueda
       done
     ;;    #Fin del primer caso


   2)
     opc2=0
     while [ "$opc2" != 5 ]
     do
     echo "Seleccionó Manejo de procesos"
     echo "Ingrese una opción: "
     echo "1) Listar Tabla de procesos por paginas"
     echo "2) Listar Tabla de procesos de un usuario"
     echo "3) Matar un proceso"
     echo "4) Número de procesos totales corriendo en el sistema"
     echo "5) Regresar al menú principal"

     read opc2
     case $opc2 in
	
	1) 
          echo " Tabla de Proceos"
          ps -fe | more
	  ;;
	2)
	  echo " Ingrese un usuario a validar"
          read usuario 2>errores.log

          if [ -n "$usuario" ]
          then

            if [ -n "$(grep $usuario /etc/passwd)" ]
            then 
              ps -U $usuario -u
            else
              echo "El usuario ingresado no existe"
            fi

          else
            echo "Ingresa una cadena válida" 
          fi

          ;;
	3)
	  echo " Ingrese el PID del proceso a matar"
          read pid
          $(kill $pid 2>errores.log)
          ;;

	4)echo " Número de procesos corriendo: "
          ps -fe | wc -l
          ;;
	5)
	  echo "Selecionó regresar al menú principal"
          ;;
	*)
	  echo " Opción desconocida"
	  ;;
 	esac
        done
     ;;

   3)
     echo "Seleccionó Monitoreo de usuarios"     

     echo "Número total de usuarios que existen en el sistema: "
     cat /etc/passwd | wc -l

     echo "Número total de grupos que existen en el sistema: "
     cat /etc/group | wc -l

     echo "Número de usuarios conectados al sistema: " 
     who | wc -l

     echo "Lista de los logines de usuarios conectados al sistema: "
     who | cut -d " " -f 1

     echo "Número de usuarios que están ejecutando procesos: "
     ps -u | cut -d " " -f 1 | uniq | wc -l
     echo " "
     ps -u | cut -d " " -f 1 | uniq

     lectura=0
     while [ "$lectura" != 3 ]
     do
      
       echo "Ingrese una forma de buscar a un usuario: "
       echo "1) login "
       echo "2) UID "
       echo "3) Salir "
       read lectura 2>errores.log
       case $lectura in
         1)
           echo "Ingresa el login de usuario: "
           read login
           esta=$(cat /etc/passwd | cut -d : -f 1 |grep $login 2>errores.log)
           if [ -n "login" ]
           then
             echo "Login: $login"
             cat /etc/passwd | cut -d: -f 1 | grep $login
             echo "UID: "
             cat /etc/passwd | grep $login | cut -d: -f 3
             echo "Grupo: "
             cat /etc/passwd | grep $login | cut -d: -f 4
             echo "Nombre: "
             cat /etc/passwd | grep $login | cut -d: -f 5
             echo "HOME: "
             cat /etc/passwd | grep $login | cut -d: -f 6
             echo "SHELL: "
             cat /etc/passwd | grep $login | cut -d: -f 7
           else
             echo "login no encontrado"
           fi
         ;;
         2)
           echo "Ingresa el UID del  usuario: "
           read uid
           aquella=$(cat /etc/passwd | cut -d : -f 3 |grep $uid 2>errores.log)
           if [ -n "aquella" ]
           then
         
               echo "Login: "
               cat /etc/passwd | grep $uid | cut -d: -f 1 
 
               echo "UID: $login"
               cat /etc/passwd | cut -d : -f 3 |grep $uid
 
               echo "Grupo: "
               cat /etc/passwd | grep $uid | cut -d: -f 4

               echo "Nombre: "
               cat /etc/passwd | grep $uid | cut -d: -f 5
             
               echo "HOME: "
               cat /etc/passwd | grep $uid | cut -d: -f 6

               echo "SHELL: "
               cat /etc/passwd | grep $uid | cut -d: -f 7
 
            else
              echo "uid no encontrado"
            fi
         ;;
         3)
           echo "Salir"
         ;;
         *)
           echo "Ingresa una opción válida." 
         ;; 
         esac
        
     done
     ;;
   4)
     echo "Seleccionó Información del sistema"
     echo "Hostname: "
     hostname
     echo "Sistema Operativo: "
     lsb_release -d 2>errores.log
     echo "Arquitectura del sistema: "
     uname -m
     echo "Presione enter para regresar al menú principal"
     ;;
   5)
     echo "Selecciono la opción de salir"
     echo "HASTA LUEGO"
     ;;
   *)
     echo "Opción desconocida"
     ;;
esac
done
