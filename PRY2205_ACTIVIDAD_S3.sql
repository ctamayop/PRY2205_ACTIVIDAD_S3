-- CASO 1:

SELECT
id_tipo_propiedad AS TIPO,

COUNT(*) AS TOTAL_PROPIEDADES,

TO_CHAR(MAX(valor_arriendo),
            'FM$999G999G990') AS MAX_ARRIENDO,

TO_CHAR(ROUND(AVG(valor_arriendo)),
            'FM$999G999G990') AS PROMEDIO_ARRIENDO,

TO_CHAR(MIN(valor_arriendo),
            'FM$999G999G990') AS MIN_ARRIENDO,

CASE
    WHEN MAX(valor_arriendo) <= 1000000
    THEN 'ESTÁNDAR'
    ELSE 'PREMIUM'
    END AS CLASIFICACION,

TO_CHAR(SUM(NVL(valor_gasto_comun, 0)),
            'FM$999G999G990') AS TOTAL_GASTOS_COMUNES

FROM propiedad

GROUP BY id_tipo_propiedad

HAVING SUM(NVL(valor_gasto_comun, 0))
       > &VALOR_TOTAL_GASTO_COMUN

ORDER BY SUM(NVL(valor_gasto_comun, 0)) DESC;

-- ======================================================================
-- CASO 2:

SELECT
    nombre_emp || ' ' || appaterno_emp AS "Nombre Empleado",

TO_CHAR(sueldo_emp, 'FM$999G999G990') AS "Sueldo con Formato",

CASE
    WHEN sueldo_emp > 2000000 THEN 'ALTO'
    ELSE 'MEDIO'
    END AS "Clasificación Sueldo",

TO_CHAR(
    TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12)
       ) AS "Años Antiguedad",

CASE
    WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12)
        BETWEEN 5 AND 10
    THEN 'Corresponde bono 5%: ' ||
        TO_CHAR(ROUND(sueldo_emp * 0.05),
                     'FM$999G999G990')

    WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12)
        BETWEEN 11 AND 20
    THEN 'Corresponde bono 10%: ' ||
        TO_CHAR(ROUND(sueldo_emp * 0.10),
                     'FM$999G999G990')

    WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) > 20
    THEN 'Corresponde bono 15%: ' ||
             TO_CHAR(ROUND(sueldo_emp * 0.15),
                     'FM$999G999G990')
END AS BONO

FROM empleado

WHERE id_categoria_emp = 3
AND id_sucursal <> &CODIGO_SUCURSAL
AND TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) > 5

ORDER BY sueldo_emp DESC;

-- ============================================================
-- CASO 3:

SELECT

CASE
    WHEN renta_cli >= 1000000 THEN 'PREMIUM'
    WHEN renta_cli >= 600000 THEN 'ALTA'
    WHEN renta_cli >= 300000 THEN 'MEDIA'
    ELSE 'BAJA'
END AS CLASIFICACION_RENTA,

COUNT(*) AS CANTIDAD_CLIENTES,

TO_CHAR(ROUND(AVG(renta_cli)),
            'FM$999G999G990') AS RENTA_PROMEDIO,

CASE
    WHEN COUNT(celular_cli) = 0
    THEN 'Clientes Sin Teléfono'
    ELSE 'Clientes con Teléfono'
END AS ESTADO_TELEFONO

FROM cliente

GROUP BY
    CASE
        WHEN renta_cli >= 1000000 THEN 'PREMIUM'
        WHEN renta_cli >= 600000 THEN 'ALTA'
        WHEN renta_cli >= 300000 THEN 'MEDIA'
        ELSE 'BAJA'
    END

HAVING AVG(renta_cli) > 200000

ORDER BY
    CASE
        WHEN CLASIFICACION_RENTA = 'ALTA' THEN 1
        WHEN CLASIFICACION_RENTA = 'MEDIA' THEN 2
        WHEN CLASIFICACION_RENTA = 'BAJA' THEN 3
        WHEN CLASIFICACION_RENTA = 'PREMIUM' THEN 4
    END;