-- Script para inicializar la base de datos de Hue
CREATE USER hue WITH PASSWORD 'hue';
CREATE DATABASE hue OWNER hue;
GRANT ALL PRIVILEGES ON DATABASE hue TO hue;
