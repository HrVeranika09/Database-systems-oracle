-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2026-06-10 21:20:38.276

-- tables
-- Table: Hospitalizacja
CREATE TABLE Hospitalizacja (
    id_hospitalizacji integer  NOT NULL,
    numer_lozka number(10)  NOT NULL,
    data_przyjecia date  NOT NULL,
    data_wypisu date  NULL,
    przyczyna varchar2(100)  NOT NULL,
    status varchar2(60)  NOT NULL,
    Szpitalna_id_sali integer  NOT NULL,
    Pacjent_id_pacjenta integer  NOT NULL,
    Pacjent_id_osoby integer  NOT NULL,
    Lekarz_id_lekarza integer  NOT NULL,
    Lekarz_id_osoby integer  NOT NULL,
    Pielegniarka_id_pielegniarki integer  NOT NULL,
    Pielegniarka_id_osoby integer  NOT NULL,
    CONSTRAINT Hospitalizacja_pk PRIMARY KEY (id_hospitalizacji)
) ;

-- Table: Lek
CREATE TABLE Lek (
    id_leku integer  NOT NULL,
    nazwa varchar2(60)  NOT NULL,
    substancja_czynna varchar2(60)  NOT NULL,
    dawkowanie varchar2(60)  NOT NULL,
    forma varchar2(60)  NOT NULL,
    stan_magazynowy number(10)  NOT NULL,
    jednostka varchar2(60)  NOT NULL,
    CONSTRAINT Lek_pk PRIMARY KEY (id_leku)
) ;

-- Table: Lekarz
CREATE TABLE Lekarz (
    id_lekarza integer  NOT NULL,
    numer_PWZ varchar2(60)  NOT NULL,
    specjalizacja varchar2(60)  NOT NULL,
    id_osoby integer  NOT NULL,
    id_oddzialu integer  NOT NULL,
    CONSTRAINT Lekarz_pk PRIMARY KEY (id_lekarza,id_osoby)
) ;

-- Table: Oddzial
CREATE TABLE Oddzial (
    id_oddzialu integer  NOT NULL,
    nazwa varchar2(60)  NOT NULL,
    numer_pietra number(10)  NOT NULL,
    liczba_miejsc number(10)  NOT NULL,
    telefon_wewnetrzny number(20)  NOT NULL,
    CONSTRAINT Oddzial_pk PRIMARY KEY (id_oddzialu)
) ;

-- Table: Osoba
CREATE TABLE Osoba (
    id_osoby integer  NOT NULL,
    imie varchar2(60)  NOT NULL,
    nazwisko varchar2(60)  NOT NULL,
    PESEL varchar2(60)  NOT NULL,
    data_urodzenia date  NOT NULL,
    adres varchar2(100)  NOT NULL,
    telefon varchar2(60)  NOT NULL,
    email varchar2(100)  NOT NULL,
    CONSTRAINT Osoba_pk PRIMARY KEY (id_osoby)
) ;

-- Table: Pacjent
CREATE TABLE Pacjent (
    id_pacjenta integer  NOT NULL,
    grupa_krwi varchar2(60)  NOT NULL,
    id_osoby integer  NOT NULL,
    CONSTRAINT Pacjent_pk PRIMARY KEY (id_pacjenta,id_osoby)
) ;

-- Table: Pielegniarka
CREATE TABLE Pielegniarka (
    id_pielegniarki integer  NOT NULL,
    numer_NPWZ varchar2(60)  NOT NULL,
    zmiana varchar2(60)  NOT NULL,
    id_osoby integer  NOT NULL,
    id_oddzialu integer  NOT NULL,
    CONSTRAINT Pielegniarka_pk PRIMARY KEY (id_pielegniarki,id_osoby)
) ;

-- Table: Pozycja_Recepty
CREATE TABLE Pozycja_Recepty (
    ilosc number(10)  NOT NULL,
    dawkowanie_szczegolowe varchar2(60)  NOT NULL,
    instrukcja varchar2(200)  NOT NULL,
    id_recepty integer  NOT NULL,
    id_leku integer  NOT NULL,
    CONSTRAINT Pozycja_Recepty_pk PRIMARY KEY (id_recepty,id_leku)
) ;

-- Table: Recepta
CREATE TABLE Recepta (
    id_recepty integer  NOT NULL,
    data_wystawienia date  NOT NULL,
    data_waznosci date  NOT NULL,
    id_wizyty integer  NOT NULL,
    CONSTRAINT Recepta_pk PRIMARY KEY (id_recepty)
) ;

-- Table: Sala_Szpitalna
CREATE TABLE Sala_Szpitalna (
    id_sali integer  NOT NULL,
    numer_sali varchar2(20)  NOT NULL,
    liczba_lozek number(20)  NOT NULL,
    typ_sali varchar2(60)  NOT NULL,
    id_oddzialu integer  NOT NULL,
    CONSTRAINT Sala_Szpitalna_pk PRIMARY KEY (id_sali)
) ;

-- Table: Wizyta
CREATE TABLE Wizyta (
    id_wizyty integer  NOT NULL,
    data date  NOT NULL,
    godzina timestamp  NOT NULL,
    rozpoznanie varchar2(200)  NULL,
    zalecenia varchar2(300)  NULL,
    status varchar2(60)  NOT NULL,
    Lekarz_id_lekarza integer  NOT NULL,
    Lekarz_id_osoby integer  NOT NULL,
    Pacjent_id_pacjenta integer  NOT NULL,
    Pacjent_id_osoby integer  NOT NULL,
    CONSTRAINT Wizyta_pk PRIMARY KEY (id_wizyty)
) ;

-- foreign keys
-- Reference: Hospitalizacja_Lekarz (table: Hospitalizacja)
ALTER TABLE Hospitalizacja ADD CONSTRAINT Hospitalizacja_Lekarz
    FOREIGN KEY (Lekarz_id_lekarza,Lekarz_id_osoby)
    REFERENCES Lekarz (id_lekarza,id_osoby);

-- Reference: Hospitalizacja_Pacjent (table: Hospitalizacja)
ALTER TABLE Hospitalizacja ADD CONSTRAINT Hospitalizacja_Pacjent
    FOREIGN KEY (Pacjent_id_pacjenta,Pacjent_id_osoby)
    REFERENCES Pacjent (id_pacjenta,id_osoby);

-- Reference: Hospitalizacja_Pielegniarka (table: Hospitalizacja)
ALTER TABLE Hospitalizacja ADD CONSTRAINT Hospitalizacja_Pielegniarka
    FOREIGN KEY (Pielegniarka_id_pielegniarki,Pielegniarka_id_osoby)
    REFERENCES Pielegniarka (id_pielegniarki,id_osoby);

-- Reference: Hospitalizacja_Sala_Szpitalna (table: Hospitalizacja)
ALTER TABLE Hospitalizacja ADD CONSTRAINT Hospitalizacja_Sala_Szpitalna
    FOREIGN KEY (Szpitalna_id_sali)
    REFERENCES Sala_Szpitalna (id_sali);

-- Reference: Lekarz_Oddzial (table: Lekarz)
ALTER TABLE Lekarz ADD CONSTRAINT Lekarz_Oddzial
    FOREIGN KEY (id_oddzialu)
    REFERENCES Oddzial (id_oddzialu);

-- Reference: Lekarz_Osoba (table: Lekarz)
ALTER TABLE Lekarz ADD CONSTRAINT Lekarz_Osoba
    FOREIGN KEY (id_osoby)
    REFERENCES Osoba (id_osoby);

-- Reference: Pacjent_Osoba (table: Pacjent)
ALTER TABLE Pacjent ADD CONSTRAINT Pacjent_Osoba
    FOREIGN KEY (id_osoby)
    REFERENCES Osoba (id_osoby);

-- Reference: Pielegniarka_Oddzial (table: Pielegniarka)
ALTER TABLE Pielegniarka ADD CONSTRAINT Pielegniarka_Oddzial
    FOREIGN KEY (id_oddzialu)
    REFERENCES Oddzial (id_oddzialu);

-- Reference: Pielegniarka_Osoba (table: Pielegniarka)
ALTER TABLE Pielegniarka ADD CONSTRAINT Pielegniarka_Osoba
    FOREIGN KEY (id_osoby)
    REFERENCES Osoba (id_osoby);

-- Reference: Pozycja_Recepty_Lek (table: Pozycja_Recepty)
ALTER TABLE Pozycja_Recepty ADD CONSTRAINT Pozycja_Recepty_Lek
    FOREIGN KEY (id_leku)
    REFERENCES Lek (id_leku);

-- Reference: Pozycja_Recepty_Recepta (table: Pozycja_Recepty)
ALTER TABLE Pozycja_Recepty ADD CONSTRAINT Pozycja_Recepty_Recepta
    FOREIGN KEY (id_recepty)
    REFERENCES Recepta (id_recepty);

-- Reference: Recepta_Wizyta (table: Recepta)
ALTER TABLE Recepta ADD CONSTRAINT Recepta_Wizyta
    FOREIGN KEY (id_wizyty)
    REFERENCES Wizyta (id_wizyty);

-- Reference: Sala_Szpitalna_Oddzial (table: Sala_Szpitalna)
ALTER TABLE Sala_Szpitalna ADD CONSTRAINT Sala_Szpitalna_Oddzial
    FOREIGN KEY (id_oddzialu)
    REFERENCES Oddzial (id_oddzialu);

-- Reference: Wizyta_Lekarz (table: Wizyta)
ALTER TABLE Wizyta ADD CONSTRAINT Wizyta_Lekarz
    FOREIGN KEY (Lekarz_id_lekarza,Lekarz_id_osoby)
    REFERENCES Lekarz (id_lekarza,id_osoby);

-- Reference: Wizyta_Pacjent (table: Wizyta)
ALTER TABLE Wizyta ADD CONSTRAINT Wizyta_Pacjent
    FOREIGN KEY (Pacjent_id_pacjenta,Pacjent_id_osoby)
    REFERENCES Pacjent (id_pacjenta,id_osoby);

-- End of file.

