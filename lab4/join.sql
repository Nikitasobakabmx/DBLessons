
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


-- -- самые старые люди среди контактов
-- д. месяц, когда есть дни рождения у соседей, но нет у семьи
-- е. метки, к которым относится максимальное количество людей
-- ж. месяц, в котором есть дни рождения у людей со всеми метками
-- 4

select * from Person as P
	WHERE dateofbirth <= ALL
	(
		select dateofbirth from Person
	);

-- /*5*/
-- EXCEPT
SELECT EXTRACT(month from dateofbirth)  from Person as P
	JOIN MarkSet as MS On MS.PersonID = P.PersonId
	Join Mark as M ON M.MarkID = MS.MarkID
	where M.type = 'Соседи'
EXCEPT 
SELECT EXTRACT(month from dateofbirth) from Person as P
	JOIN MarkSet as MS On MS.PersonID = P.PersonId
	Join Mark as M ON M.MarkID = MS.MarkID
	where M.type = 'Семья';

-- Not IN
SELECT EXTRACT(month from dateofbirth) from Person as P
	JOIN MarkSet as MS On MS.PersonID = P.PersonId
	JOIN Mark as M ON M.MarkID = MS.MarkID
	where M.type = 'Соседи' and  EXTRACT(month from dateofbirth) NOT IN(
SELECT EXTRACT(month from dateofbirth) from Person as P
	JOIN MarkSet as MS On MS.PersonID = P.PersonId
	JOIN Mark as M ON M.MarkID = MS.MarkID
	where M.type = 'Семья');

--join
	SELECT EXTRACT(month from P.dateofbirth) as mon from Person as P
		JOIN MarkSet as MS On MS.PersonID = P.PersonID
		Join Mark as M on M.MarkId = MS.MarkId
	LEFT Join
	(SELECT EXTRACT(month from P.dateofbirth) as mon1 from Person as P
		JOIN MarkSet as MS On MS.PersonID = P.PersonID
		Join Mark as M on M.MarkId = MS.MarkId
		WHERE M.type = 'Семья') AS Two
		On EXTRACT(month from P.dateofbirth) = Two.mon1
	where Two.mon1 is NULL and M.type = 'Соседи';

-- /*6*/

SELECT COUNT(PersonID) as AMOUNT, Mark.type from MarkSet
	JOIN Mark on Mark.MarkId = MarkSet.MarkId 
	GROUP BY MarkSet.MarkID, Mark.type
	HAVING COUNT(PersonID) =
	(	
		Select Max(Amount) from 
		(
			SELECT COUNT(PersonID) as AMOUNT from MarkSet
			JOIN Mark on Mark.MarkId = MarkSet.MarkId 
			GROUP BY MarkSet.MarkId
		) 
	as FOO
	);

-- 7 
SELECT EXTRACT(month from dateofbirth) FROM Person 
	where Not EXISTS
	(
		SELECT * From Mark where NOT EXISTS
		(
			Select * from MarkSet as PM
			Where Person.PersonId = PM.PersonID
			AND Mark.MarkId = PM.MarkID
		)
	);