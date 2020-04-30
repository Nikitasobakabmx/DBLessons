
/*1*/
Select P.PersonID, name, surname, patronumic from Person AS P
	JOIN Phone AS H ON H.PersonID = P.PersonID
	JOIN MarkSet AS MS ON MS.PersonID = P.PersonID
      	 JOIN Mark AS M ON M.MarkID = MS.MarkID
		WHERE type = 'Друзья' AND phonenumber LIKE '8911%';	

/*2*/
Select P.PersonID, name, surname, patronumic from Person AS P
	LEFT OUTER JOIN MarkSet AS MS 
		ON MS.PersonID = P.PersonID
	WHERE MarkID IS NULL;


/*3*/
Select P.PersonID, name, surname, patronumic from Person AS P
	Inner JOIN MarkSet
		ON P.PersonID = MarkSet.PersonID
	Inner JOIN Mark
		ON Mark.MarkID = MarkSet.MarkID
	Inner JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	Inner JOIN Mark as Mark2
		ON Mark2.MarkID = MS.MarkID
	where Mark.type = 'Коллеги' and Mark2.type = 'Соседи';

-- /*4*/
-- Select PersonID,  name, surname, patronumic, dateofbirth
-- 	from Person ORDER BY dateofbirth LIMIT 1;

-- /*5*/
-- Select DISTINCT EXTRACT(month from dateofbirth)
-- 	from Person AS P
-- 	LEFT JOIN MarkSet AS MS
-- 		ON P.PersonID = MS.PersonID
-- 	RIGHT JOIN Mark AS M
-- 		ON M.MarkID = MS.MarkID
-- 	WHERE type = 'Соседи'
-- EXCEPT
-- Select DISTINCT EXTRACT(month from dateofbirth)
-- 	from Person AS P
-- 	LEFT JOIN MarkSet AS MS
-- 		ON P.PersonID = MS.PersonID
-- 	RIGHT JOIN Mark AS M
-- 		ON M.MarkID = MS.MarkID
-- 	WHERE type = 'Семья'
-- ;

-- /*6*/

-- Select * from
-- (Select 'Соседи', COUNT(*)
-- 	from Person AS P
-- 	LEFT JOIN MarkSet AS MS
-- 		ON P.PersonID = MS.PersonID
-- 	RIGHT JOIN Mark AS M
-- 		ON M.MarkID = MS.MarkID
-- 	WHERE type = 'Соседи'
-- UNION
-- Select 'Коллеги', COUNT(*)
-- 	from Person AS P
-- 	LEFT JOIN MarkSet AS MS
-- 		ON P.PersonID = MS.PersonID
-- 	RIGHT JOIN Mark AS M
-- 		ON M.MarkID = MS.MarkID
-- 	WHERE type = 'Коллеги'
-- UNION
-- Select 'Семья', COUNT(*)
-- 	from Person AS P
-- 	LEFT JOIN MarkSet AS MS
-- 		ON P.PersonID = MS.PersonID
-- 	RIGHT JOIN Mark AS M
-- 		ON M.MarkID = MS.MarkID
-- 	WHERE type = 'Семья'
-- UNION
-- Select  'Друзья', COUNT(*)
-- 	from Person AS P
-- 	LEFT JOIN MarkSet AS MS
-- 		ON P.PersonID = MS.PersonID
-- 	RIGHT JOIN Mark AS M
-- 		ON M.MarkID = MS.MarkID
-- 	WHERE type = 'Друзья') AS FOO(type, cnt) ORDER BY cnt DESC LIMIT 1;

-- /*7*/
-- Select EXTRACT(month from dateofbirth) FROM
-- (Select p.PersonID, dateofbirth
-- 	from Person AS P
-- 	LEFT JOIN MarkSet AS MS
-- 		ON P.PersonID = MS.PersonID
-- 	RIGHT JOIN Mark AS M
-- 		ON M.MarkID = MS.MarkID
-- 	WHERE type = 'Соседи'
-- INTERSECT
-- Select p.PersonID, dateofbirth
-- 	from Person AS P
-- 	LEFT JOIN MarkSet AS MS
-- 		ON P.PersonID = MS.PersonID
-- 	RIGHT JOIN Mark AS M
-- 		ON M.MarkID = MS.MarkID
-- 	WHERE type = 'Коллеги'
-- INTERSECT
-- Select p.PersonID, dateofbirth
-- 	from Person AS P
-- 	LEFT JOIN MarkSet AS MS
-- 		ON P.PersonID = MS.PersonID
-- 	RIGHT JOIN Mark AS M
-- 		ON M.MarkID = MS.MarkID
-- 	WHERE type = 'Семья'
-- INTERSECT
-- Select p.PersonID, dateofbirth
-- 	from Person AS P
-- 	LEFT JOIN MarkSet AS MS
-- 		ON P.PersonID = MS.PersonID
-- 	RIGHT JOIN Mark AS M
-- 		ON M.MarkID = MS.MarkID
-- 	WHERE type = 'Друзья') AS FOO;
