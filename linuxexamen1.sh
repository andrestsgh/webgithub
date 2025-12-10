#!/bin/bash

while true; do
    read -p "Escribe tu nombre y pulsa intro: " usuario
    
    if [[ -z "$usuario" ]]; then
        echo "Error: debes introducir tu nombre"
        continue
    fi
    break
done

hostname $usuario
# Script para crear estructura de directorios y archivos de examen
rm bench* hello* readme*

# Crear directorio raíz (si no existe)
mkdir -p examen/{tema1,tema2,tema3}

# Tema 1 - Crear subdirectorios p1, p2, p3
mkdir -p examen/tema1/{p1,p2,p3}

# Tema 1 - P1: crear archivos
touch examen/tema1/p1/ejercicio{1,2}.txt
touch examen/tema1/p1/ejercicio{3,4,5}.{doc,pdf,odt}
touch examen/tema1/p1/imagen{1,2}.jpg
touch examen/tema1/p1/imagen{3,4}.png
touch examen/tema1/p1/libro{1,3}.txt
touch examen/tema1/p1/libro{2,4}.{pdf,doc}

# Tema 2 - Crear subdirectorios p4, p5
mkdir -p examen/tema2/{p4,p5}

# Tema 2 - P4: crear archivo
touch examen/tema2/p4/saludo1.txt

# Tema 3 - Crear subdirectorios p6, p7
mkdir -p examen/tema3/{p6,p7}

# Tema 3 - P6: crear archivo
touch examen/tema3/p6/saludo2.txt

# Crear archivos imagen en el raíz
dd if=/dev/zero of=disco-$usuario bs=1M count=2 2>/dev/null

if [[ $? -eq 0 ]]; then
    echo "disco-$usuario creado exitosamente (2MB)"
else
    echo "Error al crear disco-$usuario"
    exit 1
fi
echo "Estructura creada correctamente."
echo "Instalando herramientas necesarias. Ten paciencia, esto puede tardar un par de minutos..."
apk add e2fsprogs
clear
tree
echo "Eres el usuario root, y el nombre de tu máquina es $usuario"
echo "Ya puedes comenzar el examen..."