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


-- Calcular métricas de marketing digital como CTR (_Click-Through Rate_) y CVR (_Conversion Rate_).
SELECT tipo_interac, COUNT(interac_id) AS cant_interac
FROM interaccion_ads
WHERE ad_id=1
GROUP BY tipo_interac;

SELECT tipo_interac, COUNT(interac_id) AS total_cant_interac
FROM interaccion_ads
GROUP BY tipo_interac;
-- Permite identificar qué anuncios fueron más efectivos dentro de una campaña, osea, que tuvieron más compras
SELECT ad_id, COUNT(interac_id) AS compras_por_ad
FROM interaccion_ads
WHERE tipo_interac="Purchase"
GROUP BY ad_id
ORDER BY compras_por_ad DESC;


-- Las campañas mas efectivas segun el rango de edad 
-- descubrir que mujeres de 25–34 años convierten mejor que hombres de 18–24.


SELECT i_a.tipo_interac, a.id,  count(i_a.interac_id) as total_click
FROM interaccion_ads as i_a LEFT JOIN ads as a ON i_a.ad_id=a.id
WHERE i_a.tipo_interac="Click"
ORDER BY total_click DESC;


-- ¿Qué campañas y anuncios tuvieron mejor rendimiento en términos de conversiones y ROI?
-- ¿Qué segmentos de usuarios son los más valiosos para la empresa?
-- ¿Cómo evoluciona el comportamiento de los usuarios a lo largo del tiempo?
-- ¿Dónde se debería invertir más presupuesto para maximizar resultados?
