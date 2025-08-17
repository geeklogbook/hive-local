-- 1. Crear tabla externa desde archivos Parquet
DROP TABLE IF EXISTS flight_delay;

CREATE EXTERNAL TABLE IF NOT EXISTS flight_delay (
    flight_number STRING,
    departure_time STRING,
    arrival_time STRING,
    delay DOUBLE,
    airline STRING,
    origin STRING,
    destination STRING,
    passengers DOUBLE
)
STORED AS PARQUET
LOCATION '/user/admin/data/flights';

SELECT * FROM default.flight_delay;

-- 2. Verificar datos cargados
SELECT COUNT(*) as total_vuelos FROM flight_delay;

-- 3. Mostrar estructura de la tabla
DESCRIBE flight_delay;

-- 4. Análisis básico de retrasos
SELECT 
    airline,
    COUNT(*) as total_vuelos,
    AVG(delay) as retraso_promedio,
    MAX(delay) as max_retraso,
    MIN(delay) as min_retraso
FROM flight_delay 
GROUP BY airline
ORDER BY retraso_promedio DESC;

-- 5. Vuelos con retrasos mayores a 15 minutos
SELECT 
    flight_number,
    airline,
    origin,
    destination,
    delay,
    departure_time
FROM flight_delay 
WHERE delay > 15
ORDER BY delay DESC;

-- 6. Análisis por origen y destino
SELECT 
    origin,
    destination,
    COUNT(*) as frecuencia,
    AVG(delay) as retraso_promedio,
    SUM(passengers) as total_pasajeros
FROM flight_delay 
GROUP BY origin, destination
ORDER BY frecuencia DESC;

-- 7. Vuelos por hora del día
SELECT 
    HOUR(departure_time) as hora,
    COUNT(*) as total_vuelos,
    AVG(delay) as retraso_promedio
FROM flight_delay 
GROUP BY HOUR(departure_time)
ORDER BY hora;

-- 8. Top 5 aerolíneas por pasajeros
SELECT 
    airline,
    SUM(passengers) as total_pasajeros,
    COUNT(*) as total_vuelos,
    ROUND(SUM(passengers) / COUNT(*), 2) as pasajeros_por_vuelo
FROM flight_delay 
GROUP BY airline
ORDER BY total_pasajeros DESC
LIMIT 5;

-- 9. Análisis de eficiencia (retraso vs pasajeros)
SELECT 
    airline,
    ROUND(AVG(delay), 2) as retraso_promedio,
    ROUND(AVG(passengers), 2) as pasajeros_promedio,
    CASE 
        WHEN AVG(delay) < 10 THEN 'Excelente'
        WHEN AVG(delay) < 20 THEN 'Buena'
        ELSE 'Necesita mejora'
    END as calificacion
FROM flight_delay 
GROUP BY airline
ORDER BY retraso_promedio;

-- 10. Crear vista para análisis frecuente
CREATE VIEW vuelos_resumen AS
SELECT 
    airline,
    origin,
    destination,
    COUNT(*) as total_vuelos,
    AVG(delay) as retraso_promedio,
    SUM(passengers) as total_pasajeros,
    ROUND(AVG(passengers), 2) as pasajeros_promedio
FROM flight_delay 
GROUP BY airline, origin, destination;

-- 11. Consultar la vista
SELECT * FROM vuelos_resumen ORDER BY total_pasajeros DESC;

-- 12. Análisis de rutas más populares
SELECT 
    CONCAT(origin, ' → ', destination) as ruta,
    COUNT(*) as frecuencia,
    AVG(delay) as retraso_promedio
FROM flight_delay 
GROUP BY origin, destination
HAVING COUNT(*) > 1
ORDER BY frecuencia DESC;

-- 13. Estadísticas por mes (si tienes más datos)
-- SELECT 
--     MONTH(departure_time) as mes,
--     COUNT(*) as total_vuelos,
--     AVG(delay) as retraso_promedio
-- FROM flight_delay 
-- GROUP BY MONTH(departure_time)
-- ORDER BY mes;

-- 14. Limpiar recursos (opcional)
-- DROP VIEW vuelos_resumen;
-- DROP TABLE vuelos;
