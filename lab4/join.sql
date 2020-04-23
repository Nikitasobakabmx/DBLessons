
/*1*/
Select name, surname, patronumic from Person AS P
	JOIN Phone AS H ON H.PersonID = P.PersonID
	LEFT JOIN MarkSet AS MS ON MS.PersonID = P.PersonID
       	RIGHT JOIN Mark AS M ON M.MarkID = MS.MarkID
		WHERE type = 'Друзья' AND phonenumber LIKE '8911%';	

/*2*/
Select name, surname, patronumic from Person AS P
	LEFT OUTER JOIN MarkSet AS MS 
		ON MS.PersonID = P.PersonID
	WHERE MarkID IS NULL;


/*3*/
Select name, surname, patronumic from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Соседи'
INTERSECT
Select name, surname, patronumic from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Коллеги';

/*4*/
Select name, surname, patronumic, dateofbirth
	from Person ORDER BY dateofbirth;

/*5*/
Select DISTINCT EXTRACT(month from dateofbirth)
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Соседи'
EXCEPT
Select DISTINCT EXTRACT(month from dateofbirth)
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Семья'
;

/*6*/

Select * from
(Select 'Соседи', COUNT(*)
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Соседи'
UNION
Select 'Коллеги', COUNT(*)
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Коллеги'
UNION
Select 'Семья', COUNT(*)
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Семья'
UNION
Select  'Друзья', COUNT(*)
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Друзья') AS FOO(type, cnt) ORDER BY cnt DESC LIMIT 1;

/*7*/
Select EXTRACT(month from dateofbirth) FROM
(Select p.PersonID, dateofbirth
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Соседи'
INTERSECT
Select p.PersonID, dateofbirth
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Коллеги'
INTERSECT
Select p.PersonID, dateofbirth
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Семья'
INTERSECT
Select p.PersonID, dateofbirth
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Друзья') AS FOO;
