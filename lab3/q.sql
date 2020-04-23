update Person set ptronumic='Сергеевич';

delete from person;

MERGE INTO Person AS C
	USING Patron AS P
	ON C.PersonID == P.id
	WHEN MATCHED
	THEN UPDATE
	SET C.Patronumic=P.val;


DELETE from PERSON WHERE EXTRACT(month from dateofbirth) = 11 and PersonID in (
	Select P.PersonID
	from Person AS P
	LEFT JOIN MarkSet AS MS
		ON P.PersonID = MS.PersonID
	RIGHT JOIN Mark AS M
		ON M.MarkID = MS.MarkID
	WHERE type = 'Семья'
);