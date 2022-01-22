-- 1. Lista z nazwiskami i imionami uczestników z kolumną o wartościach 
-- ('duża', 'średnia', 'mała', 'brak'). Wartości tej kolumny zależne od kolumny obecnosc.
-- ('duża', 'średnia', 'mała', 'brak'). Wartości tej kolumny zależne od kolumny obecnosc.
-- duża - >= 90% pełnej obecności
-- średnia >= 50% i < 90%
-- mała < 50%
-- brak - nie uczestniczył.

-- 0 - nieobecny
-- 1 - obecny
-- 2 - spóźniony
-- 3 - usprawiedliwiony

WITH obecnosc AS (
SELECT uczestnik.nazwisko, uczestnik.imie, AVG(CASE
WHEN aktywnosc.obecnosc = 1 OR aktywnosc.obecnosc = 2 THEN 1 ELSE 0 END) AS frekwencja
FROM lab04.uczestnik
LEFT JOIN lab04.aktywnosc ON aktywnosc.id_uczestnik = uczestnik.id_uczestnik
GROUP BY uczestnik.id_uczestnik
)

SELECT nazwisko, imie, CASE
WHEN frekwencja >=0.9 THEN 'duza'
WHEN frekwencja >=0.5 AND frekwencja <0.9 THEN 'srednia'
WHEN frekwencja <0.5 AND frekwencja >0 THEN 'mala'
ELSE 'brak' END AS "frekwencja"
FROM obecnosc;



-- 2. Lista z nazwiskami i imionami wykładowców z kolumną o wartościach ('poniżej limitu', 'limit', 'powyżej limitu' )
-- Wartości tej kolumny zależne od ilości uczestników na kursach danego wykładowcy.
-- Np. limit to średnia ilość na kurs zaokrąglona do najbliższej liczby całkowitej.

WITH uczestnicy_wykladowcy AS (
SELECT id_wykladowca, CASE
WHEN SUM(uczestnicy_kursu.liczba_uczestnikow) IS NULL THEN 0
ELSE SUM(uczestnicy_kursu.liczba_uczestnikow) END AS liczba_uczestnikow
FROM lab04.wykladowca
LEFT JOIN lab04.wykl_kurs ON wykl_kurs.id_wykl = wykladowca.id_wykladowca
LEFT JOIN (SELECT kurs.id_kurs, COUNT(uczest_kurs.id_uczest) AS liczba_uczestnikow
FROM lab04.kurs
JOIN lab04.uczest_kurs ON uczest_kurs.id_kurs = kurs.id_kurs
GROUP BY kurs.id_kurs) AS uczestnicy_kursu on uczestnicy_kursu.id_kurs = wykl_kurs.id_kurs
GROUP BY id_wykladowca
),
srednia_wykladowcy AS (
SELECT ROUND(AVG(uczestnicy_wykladowcy.liczba_uczestnikow)) as srednia
FROM uczestnicy_wykladowcy
)

SELECT wykladowca.nazwisko, wykladowca.imie, CASE
WHEN uczestnicy_wykladowcy.liczba_uczestnikow > srednia_wykladowcy.srednia THEN 'powyżej limitu'
WHEN uczestnicy_wykladowcy.liczba_uczestnikow = srednia_wykladowcy.srednia THEN 'limit'
ELSE 'poniżej limitu' END AS "limit"
FROM lab04.wykladowca
JOIN uczestnicy_wykladowcy ON uczestnicy_wykladowcy.id_wykladowca = wykladowca.id_wykladowca
, srednia_wykladowcy;



-- 3. Korzystając z CTE pokazać średnią ilość uczestników na kursie. Nie korzystamy z agregatu AVG.

WITH uczestnicy_kursow 
AS ( SELECT count(*) as l FROM lab04.uczest_kurs),
liczba_kursow as (SELECT count(*) as l FROM lab04.kurs)

SELECT(uczestnicy_kursow.l::float / liczba_kursow.l) AS "średnia" FROM uczestnicy_kursow, liczba_kursow;