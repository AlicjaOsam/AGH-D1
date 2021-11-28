SELECT w.nazwisko, w.imie FROM lab04.wykladowca w
LEFT JOIN lab04.wykl_kurs wk ON w.id_wykladowca = wk.id_wykl                   
WHERE wk.id_wykl IS NULL

SELECT w.nazwisko, w.imie FROM lab04.wykladowca w
RIGHT JOIN lab04.wykl_kurs wk ON w.id_wykladowca = wk.id_wykl                   
WHERE w.id_wykladowca IS NULL

SELECT w.nazwisko, w.imie FROM lab04.wykladowca w
FULL OUTER JOIN lab04.wykl_kurs wk ON w.id_wykladowca = wk.id_wykl                   
WHERE w.id_wykladowca IS NULL
OR wk.id_wykl IS NULL

SELECT MAX(ocena) FROM lab04.uczest_kurs;
SELECT MIN(ocena) FROM lab04.uczest_kurs;
SELECT AVG(ocena) FROM lab04.uczest_kurs;

SELECT w.id_wykl COUNT(w.id_kurs) FROM lab04.wykl_kurs w
GROUP BY w.id_wykl