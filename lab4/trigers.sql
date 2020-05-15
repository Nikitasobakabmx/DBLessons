
-- !!! BEFORE !!!
-----------------------------------------------------------------------------
-- name null pount exception ++
-- BEFORE INSERT

DROP TRIGGER IF EXISTS name_npe ON Person;
DROP FUNCTION IF EXISTS name_npe();

CREATE OR REPLACE FUNCTION name_npe()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.Name IS NULL
    THEN 
        RAISE EXCEPTION 'Name is NULL, Не надо так';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER name_npe BEFORE INSERT ON Person
    FOR EACH ROW
    EXECUTE PROCEDURE name_npe();

INSERT INTO Person(surname) Values ('Nikita'); -- incorect
INSERT INTO Person(name) Values ('Nikita');    -- corect

-----------------------------------------------------------------------------
-- kascade delete ++
-- BEFORE DELETE
DROP TRIGGER IF EXISTS kascade_person ON Person;
DROP FUNCTION IF EXISTS kascade_person();

CREATE OR REPLACE FUNCTION kascade_person()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM MarkSet WHERE Personid = OLD.Personid;
    DELETE FROM Phone WHERE Personid = OLD.Personid;
    DELETE FROM Email WHERE Personid = OLD.Personid;
    RETURN OLD;
END;
$$;

CREATE TRIGGER kascade_person BEFORE DELETE ON Person
    FOR EACH ROW
    EXECUTE PROCEDURE kascade_person();

CALL MINIMAL_APPEND_PERSON_1(
	'Nikittoss',
	'Khmelev', 
	'Anatolevich',
	'Семья',
	'89995480802');	

-----------------------------------------------------------------------------
-- Check Phone ++

-- BEFORE INSERT AND UPDATE
DROP TRIGGER IF EXISTS Check_phone ON Phone;
DROP FUNCTION IF EXISTS Check_phone();

CREATE OR REPLACE FUNCTION Check_phone()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.PhoneNumber NOT LIKE '89%'
    THEN 
        RAISE EXCEPTION 'number is not correct';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER Check_phone BEFORE INSERT OR UPDATE ON Phone
    FOR EACH ROW
    EXECUTE PROCEDURE Check_phone();

Insert INTO Phone(PersonID, PhoneNumber) VALUES(3, '89995480802');
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- !!! AFTER !!!++

DROP TABLE my_log;

CREATE TABLE IF NOT EXISTS my_log(
    ts timestamp PRIMARY KEY DEFAULT NOW(),
    id INTEGER DEFAULT NULL,
    old_id INTEGER DEFAULT NULL,
    tab_name VARCHAR(50),
    operation VARCHAR(15), 
    args VARCHAR(200), 
    old_args VARCHAR(200)
);

-----------------------------------------------------------------------------
-- loging Person ++
-- After ALL
DROP TRIGGER IF EXISTS loging ON Person;
DROP FUNCTION IF EXISTS Loging();

CREATE OR REPLACE FUNCTION Loging()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'logging...';
    IF TG_OP = 'INSERT'
    THEN
        INSERT INTO my_log(id, tab_name, operation, args)
            VALUES(NEW.PersonID,
                CAST(TG_TABLE_NAME AS TEXT),
                TG_OP,
                CAST(NEW.* AS TEXT));
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        INSERT INTO my_log(old_id, tab_name, operation, old_args)
            VALUES(OLD.PersonID, 
                CAST(TG_TABLE_NAME AS TEXT), 
                TG_OP, 
                CAST(OLD.* AS TEXT));
        RETURN OLD;
    END IF;
    IF TG_OP = 'UPDATE'
    THEN
        INSERT INTO my_log(id, old_id, tab_name, operation, args, old_args)
            VALUES(NEW.PersonID, 
                OLD.PersonID, 
                CAST(TG_TABLE_NAME AS TEXT), 
                TG_OP, 
                CAST(NEW.* AS TEXT),
                CAST(OLD.* AS TEXT));
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER loging AFTER INSERT OR UPDATE OR DELETE ON Person
    FOR EACH ROW
    EXECUTE PROCEDURE Loging();

-----------------------------------------------------------------------------
-- clear mark ++
-- AFTER DELETE

DROP TRIGGER IF EXISTS clear_mark On MarkSet;
DROP FUNCTION IF EXISTS clear_mark();

CREATE OR REPLACE FUNCTION clear_mark()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS(
        SELECT * FROM MarkSet WHERE MarkID = OLD.MarkID
    ) 
    THEN 
        DELETE FROM Mark WHERE MarkID = OLD.MarkID;
    END IF;
    RETURN OLD;
END;
$$;

CREATE TRIGGER clear_mark AFTER DELETE ON MarkSet
    FOR EACH ROW
    EXECUTE PROCEDURE clear_mark();

-----------------------------------------------------------------------------
-- clear mark ++
-- AFTER UPDATE
