#!/bin/bash

#Hecho por:
#Edwin Uriel Santiago Camacho
#Raúl Cárdenas Ibarra
#José SIlva Grimaldo


#	En este script  se realizará el menú y el repprte

#Importacion de los modulos que se ocuparan en el menu
source ./pentest.sh
source ./port_process.sh

#Función del menú
function main(){

	opc=0
	#ciclo para repetir el menú en caso de elegir otra opción
	while true; do
		clear

#Mensaje al usuario de que opciones puede elegir
	 echo "

	    HI! $USER


       -- MENÚ OPCIONES --

	   1. 		PRUEBA DE PENETRACIÓN

	   2.		PUERTOS Y PROCESOS

	   3. 		Salir

----- 	Ingrese la opción deseada   -----
"


		read -p " "   opc #lee la opción qu eleigio el usurio

		case $opc in #casos con respecto a la desición del usuario

			#Al elegir la opción 1 hace lo siguiente:
			1) clear
				read -p "Ingresa la IP para realizar la prueba de penetracion:	" obj 
				pentest $obj
				echo
				echo Espere para continuar hasta que salga el siguiente mensaje:

				sleep 2
				;;
			#Elección 2 hace lo siguiente:
			2) clear

				echo Se mostrarán los puertos, conexiones activas, procesos sospechosos y el reporte de ellos
				view_ports
				check_process
				generate_report
				echo
				echo Espere para continuar hasta que salga el siguiente mensaje:

				sleep 2
				;;
			#Desición 3 sale del menú
			3) clear

				echo Usted ha salido del menú
				echo
				echo

				return 0
				;;
			#En caso de que no haya elegido una opción válida
			#Lanza un mensaje para que lo vuelva a intentar
			*) clear
				echo El carácter o numero es invalido vuelva a intentarlo
				echo
				echo Espere para continuat hasta que salga el siguiente mensaje:

				;;
		#sale de los casos
		esac
		#Lanza un mensaje de espera para continuar seleccionando o para salir
		echo
		read -p " Pulse enter para continuar  	.	.	 .  "  	 enter

	done

}

#llamada de la función
#main



function report (){


	echo
	# Título del reporte
	echo "Reporte del Sistema"
	echo "===================="


	# Fecha y hora actual
	echo "Fecha: $(date +%Y-%m-%d)"
	echo "Hora: $(date +%H:%M:%S)"

	# Información del sistema
	echo ""
	echo "Información del Sistema:"
	echo "------------------------"
	echo "Sistema Operativo: $(uname -a)"
	echo "Versión del Kernel: $(uname -r)"
	echo "Arquitectura: $(uname -m)"

	# Memoria RAM y uso de CPU
	echo ""
	echo "Uso de Recursos:"
	echo "----------------"
	echo "Memoria RAM: $(free -h | grep Mem: | awk '{print $2}') usado de $(free -h | grep Mem: | awk '{print $3}') disponible"
	echo "Uso de CPU: $(top -bn1 | grep Cpu | awk '{print $2}')%"

	# Procesos en ejecución
	echo ""
	echo "Procesos en Ejecución:"
	echo "---------------------"
	ps -aux | head -10

	# Espacio en disco
	echo ""
	echo "Espacio en Disco:"
	echo "-----------------"
	df -h | head -5

	# Fin del reporte
	echo ""
	echo "Fin del Reporte"
	echo "================"


}

main
report

#**********************        -NOTA-		*******************

#EL REPORTE SI SE CREO CON ESTOS COMANDO

#(main > report.txt & main)
#(report > report.txt & report)

#NO LE RECOMIENDO EJECUTARLO
#POR ALGUNA RAZÓN EL .TXT
#REPITE MUCHAS VECES REPETIR O ACTULIZAR MUCHA VECES
#ADEMÁS EL CPU ME MUESTRA EL 100% DE USO CUANDO SE EJECUTA ESTE COMANDO
#SI LO VA EJECUTAR QUITE PRIMERO EL LLAMADO DE LA FUNCIÓN DE ARRIBA
#Y DESPUES EJECUTE LOS DOS COMANDOS PARA GENERAR EL REPORTE
