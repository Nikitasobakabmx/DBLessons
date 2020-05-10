----------------------------------------------------------------------
-- MAX TYPE 
-- clear
DROP TYPE max_type;
DROP PROCEDURE IF EXISTS get_max_type_proc(inout ret max_type);
DROP FUNCTION IF EXISTS  get_max_type_func();
-- realization
create type max_type as (AMOUNT int, TYPE varchar(20));

CREATE OR REPLACE PROCEDURE get_max_type_proc(inout ret max_type = NULL)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT into ret COUNT(PersonID), Mark.type from MarkSet
	JOIN Mark on Mark.MarkId = MarkSet.MarkId 
	GROUP BY MarkSet.MarkID, Mark.type
	HAVING COUNT(PersonID) =
	(
		Select Max(tmp) from 
		(
			SELECT COUNT(PersonID) as tmp from MarkSet
			JOIN Mark on Mark.MarkId = MarkSet.MarkId 
			GROUP BY MarkSet.MarkId
		) 
	as FOO
	);
END;
$$;

CREATE OR REPLACE FUNCTION get_max_type_func() returns varchar(11)
LANGUAGE plpgsql
AS $$
BEGIN
    return (SELECT Mark.type from MarkSet
	JOIN Mark on Mark.MarkId = MarkSet.MarkId 
	GROUP BY MarkSet.MarkID, Mark.type
	HAVING COUNT(PersonID) =
	(
		Select Max(tmp) from 
		(
			SELECT COUNT(PersonID) as tmp from MarkSet
			JOIN Mark on Mark.MarkId = MarkSet.MarkId 
			GROUP BY MarkSet.MarkId
		) 
	as FOO
	));
END;
$$;
-- run
call get_max_type_proc();
select get_max_type_func();
----------------------------------------------------------------------
-- MINIMAL_APPEND_PERSON
-- clear
DROP PROCEDURE IF EXISTS MINIMAL_APPEND_PERSON (
	IN name VARCHAR(20),
	IN surname VARCHAR(20),
	IN patronumic VARCHAR(20),
	IN mark VARCHAR(10),
	IN phone CHAR(11)
);
DROP FUNCTION IF EXISTS pair_mark_person(
	IN id integer,
	IN marka integer);
DROP FUNCTION IF EXISTS put_mark(IN Itype VARCHAR(10));
DROP FUNCTION IF EXISTS put_number(IN id int, IN num VARCHAR(11));
-- realization
CREATE OR REPLACE FUNCTION pair_mark_person(
	IN id integer,
	IN marka integer)
RETURNS integer
LANGUAGE plpgsql
RETURNS NULL ON NULL INPUT
AS $$
DECLARE
	msID integer DEFAULT NULL;
BEGIN
	SELECT INTO msID MarkSetID FROM MarkSet WHERE
		PersonID = id
		and MarkID = marka;
	IF msID IS NULL 
	THEN 
		INSERT INTO MarkSet(PersonID, MarkID) VALUES(id, marka);
		SELECT INTO marka currval(
			pg_get_serial_sequence('MarkSet', 'marksetid'));
	END IF;
	RETURN msID;
END;
$$;

CREATE OR REPLACE FUNCTION put_mark(IN Itype VARCHAR(10))
RETURNS integer
LANGUAGE plpgsql
RETURNS NULL ON NULL INPUT
AS $$
DECLARE
	marka integer DEFAULT NULL;
BEGIN
	SELECT INTO marka MarkID FROM Mark WHERE type = Itype; 
	IF marka IS NULL
	THEN
		INSERT INTO Mark(type) VALUES(Itype);
		SELECT INTO marka currval(
			pg_get_serial_sequence('Mark', 'markid'));
	END IF;
	RETURN marka;
END;
$$;

CREATE OR REPLACE FUNCTION put_number(IN id int, IN num VARCHAR(11))
RETURNS int
LANGUAGE plpgsql
RETURNS NULL ON NULL INPUT
AS $$
DECLARE
	numID integer DEFAULT NULL;
BEGIN
	SELECT INTO numID PhoneID FROM Phone where 
		PersonID = id
		and PhoneNumber = num;
	IF numID IS NULL
	THEN
		IF LENGTH(num) = 11
		THEN
			INSERT INTO Phone(PersonID, PhoneNumber) VALUES(
				id, num);
		END IF;
	END IF;
	RETURN numID;
END;
$$;

CREATE OR REPLACE PROCEDURE MINIMAL_APPEND_PERSON (
	IN Iname VARCHAR(20),
	IN Isurname VARCHAR(20) DEFAULT NULL,
	IN Ipatronumic VARCHAR(20) DEFAULT NULL,
	IN Imark VARCHAR(10) DEFAULT NULL,
	IN Iphone VARCHAR(11) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
	id integer DEFAULT NULL;
	marka integer DEFAULT NULL;
BEGIN
	-- find or append person
	SELECT INTO id PersonID from Person
		where
			name = Iname 
			and surname = Isurname
			and patronumic = Ipatronumic;
	IF id IS NULL 
	THEN
		INSERT INTO Person(name, surname, patronumic)
			values(Iname, Isurname, Ipatronumic);
		SELECT INTO id currval(pg_get_serial_sequence(
			'Person', 'personid')); -- aka last_insert_id in mysql
	END IF;
	-- pair mark
	SELECT INTO marka put_mark(Imark);
	PERFORM pair_mark_person(id, marka);
	-- pair phone
	PERFORM put_number(id, Iphone);
END;
$$;
-- run
CALL MINIMAL_APPEND_PERSON(
	'Nikittoss',
	'Khmelev', 
	'Anatolevich',
	'Семья',
	'89995480802');
----------------------------------------------------------------------
-- delete full Person
-- clear
DROP FUNCTION IF EXISTS drop_person(IN id integer);
DROP PROCEDURE IF EXISTS  drop_person(
	IN Iname VARCHAR(30),
	IN Isurname VARCHAR(30)
);
-- realization
CREATE OR REPLACE FUNCTION drop_person(IN id integer)
RETURNS integer
LANGUAGE plpgsql
RETURNS NULL ON NULL INPUT
AS $$
BEGIN
	-- drop MarkSet
	DELETE FROM MarkSet WHERE PersonID = id;
	-- drop Phone
	DELETE FROM Phone WHERE PersonID = id;
	-- drop Email
	DELETE FROM Email WHERE PersonID = id;
	-- drop Person
	DELETE FROM Person WHERE PersonID = id;
	-- tiri piri tak krasivo
	RETURN id;
END;
$$;

CREATE OR REPLACE PROCEDURE drop_person(
	IN Iname VARCHAR(30),
	IN Isurname VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
DECLARE 
	id integer DEFAULT NULL;
BEGIN
	-- find Person id
	SELECT INTO id PersonID FROM Person WHERE
		name = Iname
		and surname = Isurname;
	-- and delete him
	-- if id is null nothing will happen
	PERFORM drop_person(id);
	-- success
END;
$$;
-- run
call drop_person('Nikittoss', 'Khmelev');
----------------------------------------------------------------------
-- statistics
-- clear
DROP FUNCTION IF EXISTS my_statistic();
-- realization
CREATE OR REPLACE FUNCTION my_statistic()
RETURNS TABLE (tab_name varchar(30), rows_in_tb int)
LANGUAGE plpgsql
AS $$
DECLARE 
	tmp INT;
	r VARCHAR(30);
BEGIN
	CREATE TEMP TABLE _tmp_(
		tab_name VARCHAR(30),
		rows_in_tb INT
	)
	ON COMMIT DROP;
	FOR r IN
		SELECT table_name
		FROM information_schema.tables
		WHERE table_type='BASE TABLE'
		AND table_schema='public'
	LOOP 
		EXECUTE 'SELECT count(*) FROM '
			|| r AS regclass
			INTO tmp;
		INSERT INTO _tmp_ VALUES(r, tmp);
	END LOOP;	
	RETURN QUERY SELECT * FROM _tmp_;
END;
$$; 
-- run
SELECT * FROM my_statistic();
----------------------------------------------------------------------
-- delete number and dependence
DROP PROCEDURE IF EXISTS del_num(IN num VARCHAR(11));

CREATE OR REPLACE PROCEDURE del_num(IN num VARCHAR(11))
LANGUAGE plpgsql
AS $$
DECLARE
	id int DEFAULT NULL;
	AMOUNT int DEFAULT NULL;
BEGIN
	SELECT INTO id PersonID FROM Phone WHERE PhoneNumber ~~ num;
	DELETE FROM Phone WHERE PhoneNumber ~~ num;
	SELECT INTO AMOUNT COUNT(PersonID) FROM Phone 
		WHERE PhoneID = id;
	IF AMOUNT = 0
	THEN
		PERFORM drop_person(id);
	END IF;
END;
$$;

CALL del_num('89995480802');