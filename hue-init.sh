#!/bin/bash

# Script de inicialización para Hue
# Reemplaza localhost con la IP correcta del namenode en todos los archivos de configuración

echo "Ejecutando script de inicialización de Hue..."

# Reemplazar localhost por la IP del namenode en todos los archivos de configuración
find /usr/share/hue -type f \( -name "*.ini" -o -name "*.py" -o -name "*.json" -o -name "*.xml" \) -exec sed -i 's/localhost:50070/172.18.0.4:50070/g' {} \;
find /usr/share/hue -type f \( -name "*.ini" -o -name "*.py" -o -name "*.json" -o -name "*.xml" \) -exec sed -i 's/localhost/172.18.0.4/g' {} \;

echo "Configuración actualizada. Iniciando Hue..."
