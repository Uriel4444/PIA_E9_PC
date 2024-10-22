import firewall_activator
import ipabuse
import API_SHODAN
import W_cibersecurity
import IDSML
import sys, os

def cls():
    if os.name == 'nt':
        os.system('cls')
    else:
        os.system('clear')

def menu():
    cls()
    print("\n--------- Menú Principal ---------")
    print("1. Utilizar Ip Abuse Database")
    print("2. Activar firewall")
    print("3. Captura de info de paginas http")
    print("4. busca y consulta de ip's")
    print("5. Deteccion de Intrusos")
    print("6. Salir del programa")

def op(opc):
    cls()
    if opc == 1:
        while True:
            print(f"""
              ---INICIANDO OPCIÓN 1---
              """)
            x = input("\nReportar una IP? (1)\nChecar una IP? (2)\nSalir (3): ")
            if x == "1":
                ip_used = input("Escribe la IP para verificar: ")
                categ = "22"
                comm = "comentario de prueba"
                ipabuse.reportip(ip_used, comm, categ)
                input("\nDa Enter para continuar...\n\n")
                cls()
            elif x == "2":
                ip_used = input("Ingrese la IP a verificar: ")
                ipabuse.checkip(ip_used)
                input("\nDa Enter para continuar...\n\n")
                cls()
            elif x == "3":
                print("\nSaliendo al menu")
                break
            else:
                print("Por favor, elija bien")

        input("\nDa Enter para continuar...\n\n")
    elif opc == 2:
        cls()
        print(f"""
              ---INICIANDO OPCIÓN 2---
              """)
        print("\nActivando firewall\n")
        firewall_activator.activate_firewall()
        input("\nDa Enter para continuar...\n\n")
    elif opc == 3:
        cls()
        print("")
        print(f"""
              ---INICIANDO OPCIÓN 3---
              """)
        W_cibersecurity.main()

        print("")
        input("\nDa Enter para continuar...\n\n")
    elif opc == 4:
        cls()
        print("")

        print(f"""
              ----INICIANDO OPCIÓN 4----
              """)
        
        """
        api_key == tJ73IRabIRVFSNLWZCPjzevcwswBrdt3
        Ejemplos de ip:
        76.223.26.96
        172.67.151.253
        188.216.32.202
        111.132.32.25
        """

        API_SHODAN.api_shodan()

        print("")
        input("\nDa Enter para continuar...\n\n")
    elif opc == 5:
        cls()
        while True:
            print(f"""
              ---INICIANDO OPCIÓN 5---
              """)
            Op = input("\n1.Captura de paquetes\n2.Analizar paquetes\n3.Salir al menu\nSelecciona una opción: ")
            if Op == '1':
                print("Capturando los paquetes")
                duracion = int(input("\nCuantos segundos quieres capturar paquetes? "))
                IDSML.packet_capture(duracion)
                input("\nDa Enter para continuar...\n\n")
                cls()
            elif Op == '2':
                print("Analizando los paquetes")
                IDSML.analyze_packets()
                input("\nDa Enter para continuar...\n\n")
                cls()
            elif Op == '3':
                print("\nSaliendo al menu")
                break
            else:
                print("Opción inválida. Intenta de nuevo.")

        input("\nDa Enter para continuar...\n\n")
    elif opc == 6:
        print("\n\nSaliendo del programa...")
    else:
        print("Opción no válida. Ingrese una de las opciones que están en el menú.")

def main():
    while True:
        menu()
        try:
            opc = int(input("\nSelecciona una opción: "))
            op(opc)
            if opc == 6:
                sys.exit()
                break
        except ValueError:
            print("\nPor favor, introduce un dato válido.")

if __name__ == "__main__":
    main()
