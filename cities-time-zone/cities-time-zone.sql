-- Посчитайте количество городов для каждого часового пояса в Сибирском и Приволжском федеральных округах.
-- Выведите столбцы timezone и city_count, отсортируйте по значению часового пояса.
SELECT timezone,
       COUNT(*) AS city_count
  FROM city
 WHERE federal_district IN ('Сибирский', 'Приволжский')
 GROUP BY timezone
 ORDER BY timezone;

-- Вариант с фильтрацией по UTC+5
SELECT timezone,
       COUNT(*) AS city_count
  FROM city
 WHERE federal_district IN ('Приволжский', 'Сибирский')
   AND timezone = 'UTC+5'
 GROUP BY timezone;

-- С сортировкой по количеству городов, без регионов
SELECT timezone,
       COUNT(*) AS city_count
  FROM city
 GROUP BY timezone
 ORDER BY city_count DESC;
