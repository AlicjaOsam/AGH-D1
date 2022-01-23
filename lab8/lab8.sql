--1. Napisać wyzwalacz walidujący fname i lname w tabeli person, tylko litery, bez spacji i tabulatorów. W lname dopuszczalny znak - (myślnik, pauza).

CREATE OR REPLACE FUNCTION lab04.validate_person ()
RETURNS TRIGGER AS 
$$ BEGIN
    IF NEW.fname !~ '^[A-Z][a-z]*$' THEN
        RAISE EXCEPTION 'Nieprawidłowe imię';
    END IF;
    IF NEW.lname !~ '^[A-Z][a-z]*(-?[A-Z][a-z]*)*$' THEN
        RAISE EXCEPTION 'Nieprawidłowe nazwisko';
    END IF;
    RETURN NEW;
END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER validate_person_trigger
    AFTER INSERT OR UPDATE ON lab04.person
    FOR EACH ROW EXECUTE PROCEDURE lab04.validate_person();



--2. Napisać wyzwalacz normalizujący fname i lname w tabeli person, fname i skladowe lname ( przy podwójnym nazwisku) powinny zaczynać się od dużej litery, reszta małe. Usuwamy spacje.

CREATE OR REPLACE FUNCTION lab04.normalize_person()
RETURNS TRIGGER AS 
$$ BEGIN
    NEW.fname := INITCAP(NEW.fname);
    NEW.lname := REPLACE(INITCAP(REPLACE(NEW.lname, '-', ' ')), ' ', '-');
    RETURN NEW;
END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER normalize_person_trigger
    BEFORE INSERT OR UPDATE ON lab04.person
    FOR EACH ROW EXECUTE PROCEDURE lab04.normalize_person();



--3. Napisać wyzwalacz aktualizujący tabelę zawierającą liczbę wszystkich osób w danej grupie. Uwzględnić insert, delete i update.

CREATE OR REPLACE FUNCTION lab04.update_person_group()
RETURNS TRIGGER AS 
$$ BEGIN
	DELETE FROM lab04.person_group;
	INSERT INTO lab04.person_group
	SELECT num.the_group AS "group", SUM(num.num_people) AS "number of people" FROM
	(SELECT person.primary_group AS the_group, COUNT(person.primary_group) AS num_people FROM lab04.person GROUP BY person.primary_group
	UNION
	SELECT person.secondary_group AS the_group, COUNT(person.secondary_group) AS num_people FROM lab04.person GROUP BY person.secondary_group) AS num
	GROUP BY num.the_group;
	RETURN NEW;
END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_person_group_trigger
    AFTER INSERT OR UPDATE OR DELETE ON lab04.person
    EXECUTE PROCEDURE lab04.update_person_group();

    