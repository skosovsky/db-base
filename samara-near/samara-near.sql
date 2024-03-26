-- Найдите три ближайших к Самаре города, не считая саму Самару.
  WITH samara AS (SELECT geo_lat AS samara_lat,
                         geo_lon AS samara_lon
                    FROM city
                   WHERE city = 'Самара')
SELECT city,
       (geo_lat - samara_lat) * (geo_lat - samara_lat)
           + (geo_lon - samara_lon) * (geo_lon - samara_lon) AS distance
  FROM city,
       samara
 WHERE NOT city = 'Самара'
 ORDER BY distance
 LIMIT 3;

-- С использованием алиясов
SELECT c1.city,
       ((c.geo_lat - c1.geo_lat) * (c.geo_lat - c1.geo_lat) +
        (c.geo_lon - c1.geo_lon) * (c.geo_lon - c1.geo_lon)) AS distance
  FROM city AS c,
       city AS c1
 WHERE c.city = 'Самара'
   AND c1.city != 'Самара'
 ORDER BY distance
 LIMIT 3;

-- С формулой возведения в квадрат, корнем квадратным и подзапросами
SELECT city,
       SQRT((POW(geo_lat - (SELECT geo_lat FROM city WHERE city = 'Самара'), 2) +
             (POW(geo_lon - (SELECT geo_lon FROM city WHERE city = 'Самара'), 2)))) AS distance
  FROM city
 WHERE city != 'Самара'
 ORDER BY distance
 LIMIT 3;

-- С оконными функциями
  WITH samara AS
           (SELECT city,
                   geo_lat,
                   geo_lon,
                   SUM(geo_lat) FILTER (WHERE city = 'Самара') OVER () AS lat_samara,
                   SUM(geo_lon) FILTER (WHERE city = 'Самара') OVER () AS lon_samara
              FROM city)
SELECT city,
       (geo_lat - lat_samara) * (geo_lat - lat_samara) + (geo_lon - lon_samara) * (geo_lon - lon_samara) AS sqrt
  FROM samara
 ORDER BY sqrt
 LIMIT 4;

-- С подзапросом внутри FROM
SELECT city, region, (lat1 - lat2) * (lat1 - lat2) + (lon1 - lon2) * (lon1 - lon2) AS distance
  FROM (SELECT city,
               region,
               geo_lat                                          AS lat1,
               geo_lon                                          AS lon1,
               (SELECT geo_lat FROM city WHERE city = 'Самара') AS lat2,
               (SELECT geo_lon FROM city WHERE city = 'Самара') AS lon2
          FROM city) AS t1
 ORDER BY distance
 LIMIT(4);
