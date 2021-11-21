--1.Lista uczestników kursu niemieckiego lub angielskiego.
SELECT imie, nazwisko FROM lab04.uczestnik u
JOIN lab04.uczest_kurs uk ON u.id_uczestnik = uk.id_uczest
WHERE id_kurs in (1,2,3,4,5)
UNION
SELECT imie, nazwisko FROM lab04.uczestnik u 
JOIN lab04.uczest_kurs uk ON u.id_uczestnik = uk.id_uczest
WHERE id_kurs in (6,7,8,9);

--2.Lista uczestników kursu niemieckiego i angielskiego.
SELECT imie, nazwisko FROM lab04.uczestnik u
JOIN lab04.uczest_kurs uk ON u.id_uczestnik = uk.id_uczest
WHERE id_kurs in (1,2,3,4,5)
INTERSECT
SELECT imie, nazwisko FROM lab04.uczestnik u 
JOIN lab04.uczest_kurs uk ON u.id_uczestnik = uk.id_uczest
WHERE id_kurs in (6,7,8,9);

--3.Lista uczestników kursu niemieckiego z wyłączeniem uczestników angielskiego
SELECT imie, nazwisko FROM lab04.uczestnik u
JOIN lab04.uczest_kurs uk ON u.id_uczestnik = uk.id_uczest
WHERE id_kurs in (6,7,8,9)
EXCEPT
SELECT imie, nazwisko FROM lab04.uczestnik u 
JOIN lab04.uczest_kurs uk ON u.id_uczestnik = uk.id_uczest
WHERE id_kurs in (1,2,3,4,5);

--4.Listy kursów dla których suma opłat jest większa od zadanej wartości.
SELECT ko.opis, k.id_kurs, SUM(uk.oplata) FROM lab04.kurs k 
JOIN lab04.kurs_opis ko ON k.id_nazwa = ko.id_kurs
JOIN lab04.uczest_kurs uk ON uk.id_kurs = k.id_kurs 
GROUP BY ko.opis, k.id_kurs
HAVING SUM(uk.oplata) > 4800;

--5.Lista wykładowców o największej ilości studentów na kursach.
SELECT w.imie, w.nazwisko, COUNT(uk.id_uczest) c FROM lab04.wykladowca w
JOIN lab04.wykl_kurs wk ON w.id_wykladowca = wk.id_wykl
JOIN lab04.uczest_kurs uk ON uk.id_kurs = wk.id_kurs
GROUP BY w.imie, w.nazwisko
HAVING COUNT(uk.id_uczest) > 20;

--6.Lista studentów o maksymalnej ocenie dla danej organizacji.
SELECT u.imie, u.nazwisko, o.nazwa FROM lab04.uczestnik u
JOIN lab04.uczestnik_organizacja uo ON u.id_uczestnik = uo.id_uczestnik
JOIN lab04.organizacja o ON uo.id_organizacja = o.id_organizacja
JOIN lab04.uczest_kurs uk ON u.id_uczestnik = uk.id_uczest
WHERE uk.ocena = 5
GROUP BY u.imie, u.nazwisko, o.nazwa;