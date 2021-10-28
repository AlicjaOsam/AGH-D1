
CREATE TABLE Wykladowca (
                id_wykladowca INTEGER NOT NULL,
                nazwisko VARCHAR(60) NOT NULL,
                imie VARCHAR(50) NOT NULL,
                CONSTRAINT wykladowca_pk PRIMARY KEY (id_wykladowca)
);


CREATE TABLE Kurs_opis (
                id_kurs INTEGER NOT NULL,
                opis VARCHAR(200) NOT NULL,
                CONSTRAINT kurs_opis_pk PRIMARY KEY (id_kurs)
);


CREATE TABLE Kurs (
                id_kurs INTEGER NOT NULL,
                id_grupa INTEGER NOT NULL,
                id_kurs_nazwa INTEGER NOT NULL,
                CONSTRAINT kurs_pk PRIMARY KEY (id_kurs, id_grupa)
);


CREATE TABLE wykl_kurs (
                id_wykladowca INTEGER NOT NULL,
                id_kurs INTEGER NOT NULL,
                id_grupa INTEGER NOT NULL
);


CREATE TABLE Uczestnik (
                id_uczestnik INTEGER NOT NULL,
                nazwisko VARCHAR(60) NOT NULL,
                imie VARCHAR(50) NOT NULL,
                CONSTRAINT uczestnik_pk PRIMARY KEY (id_uczestnik)
);


CREATE TABLE uczest_kurs (
                id_uczestnik INTEGER NOT NULL,
                id_kurs INTEGER NOT NULL,
                id_grupa INTEGER NOT NULL
);


ALTER TABLE wykl_kurs ADD CONSTRAINT wykladowca_wykl_kurs_fk
FOREIGN KEY (id_wykladowca)
REFERENCES Wykladowca (id_wykladowca)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Kurs ADD CONSTRAINT kurs_opis_kurs_fk
FOREIGN KEY (id_kurs)
REFERENCES Kurs_opis (id_kurs)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE uczest_kurs ADD CONSTRAINT kurs_uczest_kurs_fk
FOREIGN KEY (id_kurs, id_grupa)
REFERENCES Kurs (id_kurs, id_grupa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE wykl_kurs ADD CONSTRAINT kurs_wykl_kurs_fk
FOREIGN KEY (id_grupa, id_kurs)
REFERENCES Kurs (id_grupa, id_kurs)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE uczest_kurs ADD CONSTRAINT uczestnik_uczest_kurs_fk
FOREIGN KEY (id_uczestnik)
REFERENCES Uczestnik (id_uczestnik)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
