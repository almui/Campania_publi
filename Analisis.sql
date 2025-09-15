SELECT * FROM interaccion_ads LIMIT 10;
SELECT * FROM ads;
SELECT * FROM users;
SELECT * FROM campanias;
SELECT * FROM ad_intereses;
SELECT * FROM interes;
SELECT * FROM user_intereses;

-- Cuántas impresiones, clics y compras tuvo cada anuncio.

SELECT ad_id, COUNT(interac_id) AS impresiones_por_ad
FROM interaccion_ads
WHERE tipo_interac="Impression"
GROUP BY ad_id;

SELECT ad_id, COUNT(interac_id) AS click_por_ad
FROM interaccion_ads
WHERE tipo_interac="Click"
GROUP BY ad_id;

SELECT ad_id, COUNT(interac_id) AS compras_por_ad
FROM interaccion_ads
WHERE tipo_interac="Purchase"
GROUP BY ad_id;


WITH compras as (
    WITH click as (
        SELECT ad_id, COUNT(interac_id) AS click_por_ad
        FROM interaccion_ads
        WHERE tipo_interac="Click"
        GROUP BY ad_id
    )
    SELECT i_a.ad_id, COUNT(i_a.interac_id) AS compras_por_ad, c.click_por_ad
    FROM interaccion_ads i_a
    INNER JOIN click c ON c.ad_id=i_a.ad_id
    WHERE i_a.tipo_interac="Purchase"
    GROUP BY i_a.ad_id    
)
SELECT i.ad_id, COUNT(i.interac_id) AS impresiones_por_ad, c.click_por_ad, c.compras_por_ad, c.click_por_ad/COUNT(i.interac_id) as cvr
FROM interaccion_ads i
INNER JOIN compras c ON c.ad_id=i.ad_id
WHERE i.tipo_interac="Impression"
GROUP BY i.ad_id
ORDER BY i.ad_id ASC;



-- Calcular métricas de marketing digital como CTR (_Click-Through Rate_) y CVR (_Conversion Rate_).
SELECT tipo_interac, COUNT(interac_id) AS cant_interac
FROM interaccion_ads
WHERE ad_id=1
GROUP BY tipo_interac;

SELECT tipo_interac, COUNT(interac_id) AS total_cant_interac
FROM interaccion_ads
GROUP BY tipo_interac;


WITH compras as (
    WITH click as (
        SELECT ad_id, COUNT(interac_id) AS click_por_ad
        FROM interaccion_ads
        WHERE tipo_interac="Click"
        GROUP BY ad_id
    )
    SELECT i_a.ad_id, COUNT(i_a.interac_id) AS compras_por_ad, c.click_por_ad
    FROM interaccion_ads i_a
    INNER JOIN click c ON c.ad_id=i_a.ad_id
    WHERE i_a.tipo_interac="Purchase"
    GROUP BY i_a.ad_id    
)
SELECT i.ad_id, c.click_por_ad/COUNT(i.interac_id) AS CTR, c.compras_por_ad/c.click_por_ad AS CVR 
FROM interaccion_ads i
INNER JOIN compras c ON c.ad_id=i.ad_id
WHERE i.tipo_interac="Impression"
GROUP BY i.ad_id
ORDER BY i.ad_id ASC;



-- Permite identificar qué anuncios fueron más efectivos dentro de una campaña, osea, qué anuncios tuvieron más compras
SELECT ad_id, COUNT(interac_id) AS compras_por_ad
FROM interaccion_ads
WHERE tipo_interac="Purchase"
GROUP BY ad_id
ORDER BY compras_por_ad DESC;



-- Insights
-- Ad con las mas ventas segun el rango de edad 
SELECT i_a.ad_id, COUNT(i_a.interac_id) AS compras_por_ad, u.grupo_edad
FROM interaccion_ads as i_a
LEFT JOIN users AS u ON i_a.user_id=u.id
WHERE i_a.tipo_interac="Purchase"
GROUP BY i_a.ad_id, u.grupo_edad
ORDER BY compras_por_ad DESC;

SELECT c.nombre, COUNT(i_a.interac_id) AS compras_por_campania, u.grupo_edad
FROM interaccion_ads as i_a 
INNER JOIN ads AS a ON a.id=i_a.ad_id
INNER JOIN campanias AS c ON c.id= a.camp_id
LEFT JOIN users AS u ON i_a.user_id=u.id
WHERE i_a.tipo_interac="Purchase"
GROUP BY c.nombre, u.grupo_edad
ORDER BY compras_por_campania DESC;

SELECT
    u.genero,
    u.grupo_edad,
    COUNT(i.interac_id) AS total_compras,
    interes.nombre As intereses_user
FROM interaccion_ads i
INNER JOIN users u ON i.user_id = u.id
INNER JOIN ads a ON i.ad_id=a.id
INNER JOIN user_intereses u_i ON i.user_id=u_i.user_id
INNER JOIN interes ON interes.id=u_i.interes_id
WHERE i.tipo_interac = 'Purchase'
GROUP BY u.genero, u.grupo_edad, interes.nombre
ORDER BY total_compras DESC;

SELECT
    u.genero,
    u.grupo_edad,
    COUNT(i.interac_id) AS total_compras,
    u.interes As intereses_user
FROM interaccion_ads i
INNER JOIN users u ON i.user_id = u.id
INNER JOIN ads a ON i.ad_id=a.id
WHERE i.tipo_interac = 'Impression'
GROUP BY u.genero, u.grupo_edad, u.interes
ORDER BY total_compras DESC;



SELECT
    COUNT(i.interac_id) AS total_compras,
    u.interes As intereses_user,
    a.interes_target AS intereses_target_ad
FROM interaccion_ads i
INNER JOIN users u ON i.user_id = u.id
INNER JOIN ads a ON i.ad_id=a.id
WHERE i.tipo_interac = 'Purchase'
GROUP BY u.interes, a.interes_target
ORDER BY total_compras DESC;


-- ¿Qué campañas y anuncios tuvieron mejor rendimiento en términos de conversiones?

SELECT
    c.nombre AS nombre_campania,
    a.id AS ad_id,
    COUNT(i.interac_id) AS total_compras
FROM interaccion_ads i
INNER JOIN ads a ON i.ad_id = a.id
INNER JOIN campanias c ON a.camp_id = c.id
WHERE i.tipo_interac = 'Purchase'
GROUP BY c.id, a.id
ORDER BY total_compras DESC;





-- ¿Qué segmentos de usuarios son los más valiosos para la empresa?

SELECT 
    u.pais,
    u.ciudad,
    u.grupo_edad,
    u.genero,
    COUNT(i.interac_id) AS compras
FROM interaccion_ads i
INNER JOIN users u ON i.user_id = u.id
WHERE i.tipo_interac = 'Purchase'
GROUP BY u.pais, u.ciudad, u.grupo_edad, u.genero
ORDER BY compras DESC;


-- ¿Cómo evoluciona el comportamiento de los usuarios a lo largo del tiempo?

SELECT 
    DATE(fecha) AS dia,
    COUNT(CASE WHEN tipo_interac = 'Click' THEN 1 END) AS total_clicks,
    COUNT(CASE WHEN tipo_interac = 'Purchase' THEN 1 END) AS total_compras
FROM interaccion_ads
GROUP BY DATE(fecha)
ORDER BY dia ASC;



-- ¿Qué usuarios solo hacen clics pero no compran?

SELECT
    u.genero,
    u.grupo_edad,
    COUNT(i.interac_id) AS cantidad_de_usuarios,
    interes.nombre As intereses_user
FROM interaccion_ads i
INNER JOIN users u ON i.user_id = u.id
INNER JOIN ads a ON i.ad_id=a.id
INNER JOIN user_intereses u_i ON i.user_id=u_i.user_id
INNER JOIN interes ON interes.id=u_i.interes_id
WHERE i.tipo_interac= "Click" AND i.tipo_interac != 'Purchase'
GROUP BY u.genero, u.grupo_edad, interes.nombre
ORDER BY cantidad_de_usuarios DESC;
-- ¿Quiénes comentan pero nunca dan like?
SELECT
    u.genero,
    u.grupo_edad,
    COUNT(i.interac_id) AS cantidad_de_usuarios,
    interes.nombre As intereses_user
FROM interaccion_ads i
INNER JOIN users u ON i.user_id = u.id
INNER JOIN ads a ON i.ad_id=a.id
INNER JOIN user_intereses u_i ON i.user_id=u_i.user_id
INNER JOIN interes ON interes.id=u_i.interes_id
WHERE i.tipo_interac= "Comment" AND i.tipo_interac != 'Like'
GROUP BY u.genero, u.grupo_edad, interes.nombre
ORDER BY cantidad_de_usuarios DESC;

-- ¿Quiénes tienden a compartir más que comprar?
SELECT
    u.genero,
    u.grupo_edad,
    COUNT(i.interac_id) AS cantidad_de_usuarios,
    interes.nombre As intereses_user
FROM interaccion_ads i
INNER JOIN users u ON i.user_id = u.id
INNER JOIN ads a ON i.ad_id=a.id
INNER JOIN user_intereses u_i ON i.user_id=u_i.user_id
INNER JOIN interes ON interes.id=u_i.interes_id
WHERE i.tipo_interac= "Comment" AND i.tipo_interac != 'Like'
GROUP BY u.genero, u.grupo_edad, interes.nombre
ORDER BY cantidad_de_usuarios DESC;