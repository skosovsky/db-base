-- определите последний день 2005 года, когда была опубликована хотя бы одна книга, ответ в формате гггг-мм-дд
SELECT publication_date
  FROM books
 WHERE publication_date <= '2005-12-31'
 ORDER BY publication_date DESC
 LIMIT 1;

-- используя max и between
SELECT MAX(publication_date)
  FROM books
 WHERE publication_date BETWEEN '2005-01-01' AND '2005-12-31';

-- используя max и like
SELECT MAX(publication_date)
  FROM books
 WHERE publication_date LIKE '2005%';

-- найдите книгу, опубликованную в четвертый четверг сентября 2005 года, укажате book_id книги
SELECT book_id
  FROM books
 WHERE DATE(publication_date, 'weekday 4')
   AND publication_date BETWEEN '2005-09-01' AND '2005-09-30'
   AND publication_date >= DATE('2005-09-01', '+21 days')
 ORDER BY publication_date
 LIMIT 1;

-- date с несколькими аргументами
SELECT book_id
  FROM books
 WHERE publication_date = DATE('2005-09-01', '+21 days', 'weekday 4');

-- date с множеством аргументов
SELECT book_id, publication_date
  FROM books
 WHERE publication_date = DATE('2005-01-01', 'start of year', '8 months', '21 days', 'weekday 4');

-- с использованием оконной функции
SELECT book_id
  FROM books
 WHERE publication_date = (SELECT thursday
                             FROM (SELECT DATE(publication_date, 'weekday 4')                              AS thursday,
                                          DENSE_RANK() OVER (ORDER BY DATE(publication_date, 'weekday 4')) AS thursday_numbering
                                     FROM books
                                    WHERE publication_date BETWEEN '2005-09-01' AND '2005-09-30') AS subtable
                            WHERE thursday_numbering = 4);
