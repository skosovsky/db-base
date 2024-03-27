-- посчитать количество слов из трех букв, заканчивающиеся на 'т'
SELECT COUNT(word)
  FROM words
 WHERE word LIKE '__т';

-- с измерением длины
SELECT COUNT(*)
  FROM words
 WHERE LENGTH(word) = 3
   AND word LIKE '%т';

-- выберите из таблицы words слова на букву з, у которых вторая буква НЕ а. Отсортируйте по убыванию (столбец freq).
SELECT word
  FROM words
 WHERE word LIKE 'з%'
   AND word NOT LIKE '_а%'
 ORDER BY freq DESC;

-- с приведением типа и glob
SELECT word
  FROM words
 WHERE word GLOB 'з[^а]*'
 ORDER BY CAST(freq AS real) DESC
 LIMIT 2;

-- с поиском внутри строк
SELECT word
  FROM words
 WHERE SUBSTR(word, 1, 1) = 'з'
   AND SUBSTR(word, 2, 1) != 'а'
 ORDER BY freq DESC
 LIMIT 2;

-- посчитайте среднюю популярность (freq) по всем словам, округлите до целого значения,
-- получилось некторое значение, теперь отнесите каждое слово к одной из двух категорий rare или frequent
-- посчитайте количество frequent-слов, которые начинаются на `я`, сколько их?
SELECT COUNT(*) AS frequent_words_starting_with_я
  FROM (SELECT IIF(freq >= N, 'frequent', 'rare') AS category
          FROM words,
               (SELECT ROUND(AVG(freq)) AS N FROM words) AS avg_freq
         WHERE SUBSTR(word, 1, 1) = 'я') AS categorized_words
 WHERE category = 'frequent';

-- вариант с подразпросами
  WITH tmp AS (SELECT ROUND(AVG(freq)) AS average
                 FROM words),
       stats AS (SELECT word,
                        IIF(freq < average, 'rare', 'frequent') AS category
                   FROM words,
                        tmp)
SELECT COUNT(*)
  FROM stats
 WHERE category = 'frequent'
   AND word LIKE 'я%';

-- простой вариант
SELECT COUNT(*)
  FROM words
 WHERE IIF(freq > (SELECT AVG(freq) FROM words), 'frequent', 'rare') = 'frequent'
   AND word LIKE 'я%';

-- вариант с 2 подзапросами и удачным псевдонимом
  WITH popularity AS (SELECT word, ROUND(freq) AS popularity
                        FROM words)
SELECT COUNT(*) AS frequent_t_words
  FROM popularity
 WHERE popularity >= (SELECT ROUND(AVG(popularity))
                        FROM popularity)
   AND word LIKE 'я%';
