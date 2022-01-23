--1. Utworzyć funkcję,  która dostarcza listę z nazwiskami, imionami i adresem email uczestników dla organizacji. 
--Identyfikator organizacji jest argumentem funkcji.

CREATE OR REPLACE FUNCTION lab04.lista_uczestnikow_organizacji (id_org int)
RETURNS TABLE (nazwisko VARCHAR, imie VARCHAR, email VARCHAR) AS
$$
BEGIN
    RETURN QUERY
    SELECT u.nazwisko, u.imie, u.email FROM lab04.uczestnik U 
    JOIN lab04.uczestnik_organizacja u_org USING(id_uczestnik)
    WHERE u_org.id_organizacja = id_org;
END;
$$
LANGUAGE 'plpgsql';

SELECT * FROM lab04.lista_uczestnikow_organizacji(1);



--2. Utworzyć funkcję,  która dostarcza ilość studentów dla kursów danego języka. Nazwa języka jest argumentem funkcji.

CREATE OR REPLACE FUNCTION lab04.jezyk(jezyk varchar)
RETURNS bigint AS
$$
    SELECT count(*) FROM lab04.kurs_opis KO
    JOIN lab04.kurs KU ON ku.id_nazwa = KO.id_kurs
    JOIN lab04.uczest_kurs UK on KU.id_kurs = KO.id_kurs
    JOIN lab04.uczestnik UCZ on UCZ.id_uczestnik = UK.id_uczest
    WHERE jezyk like CONCAT(CONCAT('%', jezyk),'%');
$$
LANGUAGE SQL;

SELECT * FROM lab04.jezyk('Język angielski%');



--3. Utworzyć funkcję,  która dostarcza listę wykładowców prowadzących kursy dla zadanej organizacji. 
--Argumentem funkcji jest adres strony np. www.uj.edu.pl.

CREATE OR REPLACE FUNCTION lab04.lista_wykladowcow(adres_strony VARCHAR)
RETURNS TABLE(nazwisko VARCHAR, imie VARCHAR) AS
$$
    SELECT nazwisko, imie
    FROM lab04.wykladowca WY
    JOIN lab04.uczestnik_organizacja UO USING(id_wykladowca)
    JOIN lab04.organizacja ORG USING(id_organizacja)
    WHERE org.strona_www like adres_strony;
$$
LANGUAGE SQL;

SELECT * FROM lab04.lista_wykladowcow('www.uj.edu.pl');



--4. Utworzyć funkcję,  która zwraca napis ( string) którego zawartością jest lista. Wiersze listy zawierają  opis kursu, data rozpoczęcia, data zakończenia oddzielone średnikami. Każdy wiersz jest umieszczony w nawiasach () i oddzielony przecinkiem.

CREATE OR REPLACE FUNCTION lab04.napis()
RETURNS text AS
$$
    DECLARE
    id INTEGER;
        rec RECORD;
        records TEXT DEFAULT '';
    BEGIN
        id := 0;
        FOR rec IN (SELECT opis, data_rozpoczecia ,data_zakonczenia FROM lab04.kurs_opis JOIN lab04.kurs ON kurs_opis.id_kurs=kurs.id_nazwa )
        LOOP
        IF id != 0 THEN
            records := records || ',' || '(' || rec.opis || ';' || rec.data_rozpoczecia || ';' || rec.data_zakonczenia || ')';
        END IF;

        IF id = 0 THEN
            records := '(' || rec.opis || ';' || rec.data_rozpoczecia || ';' || rec.data_zakonczenia || ')';
        id := 1 ;
        END IF;    
        END LOOP;
    RETURN records;
END;
$$
LANGUAGE 'plpgsql';

SELECT * FROM lab04.napis();