import subprocess
import platform
import os, shutil

# Obtenemos el directorio actual del archivo `main.py`
current_dir = os.path.dirname(os.path.abspath(__file__))

powershell_script = os.path.join(current_dir, "menu.ps1")
bash_script = os.path.join(current_dir, "main.sh")
python_script = os.path.join(current_dir, "main_python.py")

def check_requirements():
    # Verificación de PowerShell
    if os.name == "nt" and not shutil.which("powershell"):
        print("PowerShell no está instalado.")
        return False

    # Verificación de Git Bash
    if os.name == "nt" and not shutil.which("git-bash"):
        print("Git Bash no está instalado.")
        return False

    # Verificación de permisos de ejecución para scripts de Bash y Python
    if not os.access(bash_script, os.X_OK):
        print(f"No tienes permisos de ejecución para el script de Bash: {bash_script}")
        return False

    if not os.access(python_script, os.X_OK):
        print(f"No tienes permisos de ejecución para el script de Python: {python_script}")
        return False

    return True


def powershell():
    try:
        if platform.system() == "Windows":
            subprocess.Popen(f"powershell -Command \"Start-Process powershell -ArgumentList '-File \"{powershell_script}\"', '-NoExit' -Verb RunAs\"", shell=True)
        else:
            print("PowerShell solo está disponible en Windows.")
    except Exception as e:
        print("Error ejecutando el programa principal de PowerShell como administrador:", e)

def bash():
    if check_requirements == True:
        print("Bash está disponible")
    try:
        if platform.system() == "Windows":
            bash_path = r"S:\Git\git-bash.exe"
            subprocess.Popen([bash_path, bash_script], shell=True)
        else:
            subprocess.Popen(["sudo", "bash", bash_script])
    except Exception as e:
        print("Error ejecutando el programa principal de Bash como administrador:", e)

def python():
    try:
        if platform.system() == "Windows":
            subprocess.Popen(f"powershell -Command \"Start-Process python -ArgumentList '{python_script}' -Verb RunAs\"", shell=True)
        else:
            subprocess.Popen(["sudo", "python3", python_script])
    except Exception as e:
        print("Error ejecutando el programa principal de Python como administrador:", e)

def main_menu():
    while True:
        print("\nSelecciona el tipo de programa principal a ejecutar:")
        print("1. PowerShell")
        print("2. Bash")
        print("3. Python")
        print("4. Requisitos")
        print("5. Salir")

        opc = input("Ingresa tu opción (1-4): ")

        if opc == '1':
            powershell()
        elif opc == '2':
            bash()
        elif opc == '3':
            python()
        elif opc == '4':
            check_requirements()
        elif opc == '5':
            print("Saliendo del menú principal...")
            break
        else:
            print("Opción no válida. Intenta de nuevo.")

if __name__ == "__main__":
    main_menu()
