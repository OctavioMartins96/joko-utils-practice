#!/bin/bash

#===================================================================
# Script de automatizacion de construccion y verificacion (maven)
#===================================================================

#1. Configuracion inicial
#Sale inmediatamente si algo falla

set -e
MVN_CMD="mvn"

echo "=========================================="
echo "Verificando entorno..."
echo -e "==========================================\n"


#2. Verificacion de las herramientas

java --version
${MVN_CMD} --version

#3. Verificacion del pom.xml

if [ ! -f "pom.xml" ]; then
	echo "Error: El archivo pom.xml no fuen encontrado."
	exit 1
fi

echo -e "\n=========================================="
echo "Verificacion del pom.xml: OK"
echo "=========================================="

#4. Ejecutar el ciclo de vida de maven

echo -e "\n--- Inicando limpieza (clean) ---\n"
${MVN_CMD} clean

echo -e "\n--- Inicando validacion (validate) ---\n"
${MVN_CMD} validate

echo -e "\n--- Inicando compilacion (compile) ---\n"
${MVN_CMD} compile

echo -e "\n--- Inicando pruebas unitarias (test) ---\n"
${MVN_CMD} test

echo -e "\n--- Inicando empaquetado (package) ---\n"
${MVN_CMD} package

#5. Mensaje de exito
echo -e "\n=========================================="
echo "Construccion Exitosa"
echo "=========================================="

#6. Buscar el artefacto generado y mostrarlo

ARTIFACT=$(find target/ -name "*.jar" -o -name "*.war")

if [ -f "${ARTIFACT}" ]; then
	echo -e "\n=========================================="
	echo "El artefacto fue generado"
	echo "Ruta: ${PWD}/${ARTIFACT}"
	echo "=========================================="
else
	echo -e "\nNo se encontro el artefacto .jar o .war en la carpeta target"
fi
