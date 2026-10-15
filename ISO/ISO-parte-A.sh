#!/bin/bash

DIRECTORIO="$HOME/linux"

if [ -d "$DIRECTORIO" ]; then
    rm -rf "$DIRECTORIO"
fi
cd $HOME
echo "Creando la estructura de directorios..."
mkdir -p linux/tema1/examen/e1 linux/tema1/examen/e2 linux/tema1/practicas/p1 linux/tema1/practicas/p2 linux/tema1/practicas/p3 \
linux/tema2/ejercicios/ej1 linux/tema2/ejercicios/ej2 linux/tema2/ejercicios/ej3 linux/tema2/practicas/p4 linux/tema2/practicas/p5 linux/tema2/practicas/p6 \
linux/tema3/practicas/p7 linux/tema3/practicas/p8 \
linux/tema4/practicas/p10 linux/tema4/practicas/p9 \
linux/tema5/practicas/p11/parte1 linux/tema5/practicas/p11/parte2 linux/tema5/practicas/p12 \
linux/tema6/examen/e3/practica linux/tema6/examen/e3/teoria linux/tema6/examen/e4
echo "Estructura creada con éxito!"
