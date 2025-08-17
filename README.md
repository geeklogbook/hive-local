Hive Local - Hadoop Cluster con Hive y Parquet

Un entorno completo de desarrollo local para trabajar con Hadoop, Hive y archivos Parquet. 

## Características

- **Hadoop 2.7.4** con HDFS y YARN
- **Hive 2.3.2** con metastore PostgreSQL
- **Hue 4.6.0** para interfaz web
- **PostgreSQL** para metadatos
- **Scripts de conversión** CSV a Parquet
- **Docker Compose** para despliegue fácil

## Prerrequisitos

- Docker y Docker Compose
- Python 3.7+ (para scripts de conversión)
- 8GB+ RAM disponible
- Puertos disponibles: 50070, 50075, 8088, 10000, 9083, 5432, 8888

## Instalación

### Instalar dependencias Python
```
pip install -r requirements.txt
```

### Preparar datos
```
mkdir -p data
```

### Levantar servicios
```
docker-compose up -d
```
### Convertir CSV a Parquet

```
python parquet_converter.py
```

### Conectar con Hive

```bash
docker exec -it hive-local-hive-server-1 beeline -u jdbc:hive2://localhost:10000

python hive_client.py
```

### Ejemplos de queries

```sql
-- Crear tabla externa desde Parquet
CREATE EXTERNAL TABLE vuelos (
    flight_number STRING,
    departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
    delay INT
)
STORED AS PARQUET
LOCATION '/data/';

-- Consultar datos
SELECT * FROM vuelos LIMIT 10;
```

## Configuración

### Variables de entorno
- `hadoop-hive.env`: Configuración de Hadoop y Hive
- `hue-overrides.ini`: Configuración personalizada de Hue

### Volúmenes Docker
- `namenode`: Datos del namenode HDFS
- `datanode`: Datos del datanode HDFS  
- `pg_data`: Base de datos Hue

