-- PROJEKT: System Zarządzania Placówką Medyczną "MediCare"
--

-- A. POLECENIA SELECT Z WARUNKIEM WHERE (5 zapytań)
-- 



-- A1. Zadanie: Wyświetl dane osobowe pacjentów z grupą krwi A+ lub O+.


SELECT
 o.imie,
 o.nazwisko,
 o.PESEL,
 p.grupa_krwi

FROM Pacjent p

JOIN Osoba o ON p.id_osoby = o.id_osoby

WHERE p.grupa_krwi IN ('A+', 'O+')

ORDER BY o.nazwisko;



-- A2. Zadanie: Wyświetl wizyty odbyte w kwietniu 2026 roku.


SELECT
 w.id_wizyty,
 w.data,
 w.rozpoznanie,
 w.status

FROM Wizyta w

WHERE w.data >= TO_DATE('2026-04-01','YYYY-MM-DD')
  
AND w.data <= TO_DATE('2026-04-30','YYYY-MM-DD')
  
AND w.status = 'odbyta'
ORDER BY w.data;



-- A3. Zadanie: Wyświetl lekarzy ze specjalizacją kardiologiczną.


SELECT
 o.imie,
 o.nazwisko,
 l.numer_PWZ,
 l.specjalizacja

FROM Lekarz l

JOIN Osoba o ON l.id_osoby = o.id_osoby

WHERE l.specjalizacja = 'Kardiologia'
ORDER BY o.nazwisko;



-- A4. Zadanie: Wyświetl leki, których stan magazynowy
 jest niższy niż 200 sztuk (alert niedoboru zapasów).


SELECT
 nazwa,
 substancja_czynna,
 forma,
 stan_magazynowy,
  jednostka

FROM Lek

WHERE stan_magazynowy < 200

ORDER BY stan_magazynowy ASC;



-- A5. Zadanie: Wyświetl aktywne hospitalizacje pacjentów aktualnie przebywających w szpitalu.


SELECT
 o.imie,
 o.nazwisko,
 s.numer_sali,
 h.numer_lozka,
 h.data_przyjecia,
 h.przyczyna

FROM Hospitalizacja h

JOIN Pacjent p ON h.Pacjent_id_pacjenta = p.id_pacjenta
                      
AND h.Pacjent_id_osoby = p.id_osoby

JOIN Osoba o ON p.id_osoby = o.id_osoby

JOIN Sala_Szpitalna s ON h.Szpitalna_id_sali = s.id_sali

WHERE h.status = 'aktywna'

ORDER BY h.data_przyjecia;




-- B. POLECENIA SELECT ZE ZŁĄCZENIEM TABEL (5 zapytań)



-- B1. Zadanie: Wyświetl wszystkie wizyty wraz z imieniem
 i nazwiskiem pacjenta, lekarza oraz jego specjalizacją.


SELECT
 w.data,
 l.specjalizacja,
 w.rozpoznanie,
 w.status
op.imie AS imie_pacjenta,
 
op.nazwisko AS nazwisko_pacjenta,
    
ol.imie AS imie_lekarza,
    
ol.nazwisko AS nazwisko_lekarza,
   
FROM Wizyta w

JOIN Pacjent p ON w.Pacjent_id_pacjenta = p.id_pacjenta
               
AND w.Pacjent_id_osoby = p.id_osoby

JOIN Osoba op ON p.id_osoby = op.id_osoby

JOIN Lekarz l ON w.Lekarz_id_lekarza = l.id_lekarza
               
AND w.Lekarz_id_osoby = l.id_osoby

JOIN Osoba ol ON l.id_osoby = ol.id_osoby

ORDER BY w.data DESC;



-- B2. Zadanie: Wyświetl skład każdej recepty – jakie leki,
 w jakiej ilości i z jakim dawkowaniem zostały
 przepisane. Dane pacjenta i lekarza pobierz przez Wizytę.

SELECT
 r.id_recepty,
 r.data_wystawienia,
 lk.forma,
 pr.ilosc,
 pr.dawkowanie_szczegolowe
op.imie AS imie_pacjenta,
    
op.nazwisko AS nazwisko_pacjenta,
    
ol.imie AS imie_lekarza,
    
ol.nazwisko AS nazwisko_lekarza,
    
lk.nazwa AS lek,
 
FROM Recepta r

JOIN Wizyta w ON r.id_wizyty = w.id_wizyty

JOIN Pacjent p ON w.Pacjent_id_pacjenta = p.id_pacjenta
                       
AND w.Pacjent_id_osoby = p.id_osoby

JOIN Osoba op ON p.id_osoby = op.id_osoby

JOIN Lekarz l ON w.Lekarz_id_lekarza = l.id_lekarza
                       
AND w.Lekarz_id_osoby = l.id_osoby

JOIN Osoba ol ON l.id_osoby = ol.id_osoby

JOIN Pozycja_Recepty pr ON r.id_recepty = pr.id_recepty

JOIN Lek lk ON pr.id_leku = lk.id_leku

ORDER BY r.id_recepty, lk.nazwa;



-- B3. Zadanie: Wyświetl zakończone hospitalizacje
 z datą przyjęcia, datą wypisu i liczbą dni pobytu.


SELECT
 o.imie,
 o.nazwisko,
 s.numer_sali,
 h.data_przyjecia,
    h.data_wypisu,
od.nazwa AS oddzial,

(h.data_wypisu - h.data_przyjecia) AS dni_pobytu

FROM Hospitalizacja h

JOIN Pacjent p ON h.Pacjent_id_pacjenta = p.id_pacjenta
                       
AND h.Pacjent_id_osoby = p.id_osoby

JOIN Osoba o ON p.id_osoby = o.id_osoby

JOIN Sala_Szpitalna s  ON h.Szpitalna_id_sali = s.id_sali

JOIN Oddzial od ON s.id_oddzialu = od.id_oddzialu

WHERE h.status = 'zakonczona'

ORDER BY h.data_przyjecia;



-- B4. Zadanie: Wyświetl wszystkie sale szpitalne z nazwą
 oddziału. Uwzględnij sale bez aktualnych hospitalizacji
 (LEFT JOIN).


SELECT
 s.numer_sali,
 s.typ_sali,
 s.liczba_lozek,
od.nazwa AS oddzial,

COUNT(h.id_hospitalizacji) AS aktywne_hospitalizacje

FROM Sala_Szpitalna s

JOIN Oddzial od ON s.id_oddzialu = od.id_oddzialu

LEFT JOIN Hospitalizacja h ON h.Szpitalna_id_sali = s.id_sali
                          
AND h.status = 'aktywna'

GROUP BY s.id_sali, s.numer_sali, od.nazwa, s.typ_sali, s.liczba_lozek

ORDER BY od.nazwa, s.numer_sali;



-- B5. Zadanie: Wyświetl pielęgniarki pracujące na nocnej
 zmianie wraz z nazwą oddziału.


SELECT
 o.imie,
 o.nazwisko,
 pi.numer_NPWZ,
 pi.zmiana,
 
od.nazwa AS oddzial,
    
od.numer_pietra AS pietro

FROM Pielegniarka pi

JOIN Osoba o  ON pi.id_osoby = o.id_osoby

JOIN Oddzial od ON pi.id_oddzialu = od.id_oddzialu

WHERE pi.zmiana = 'nocna'

ORDER BY od.nazwa;




-- C. POLECENIA SELECT Z GROUP BY I HAVING (5 zapytań)



-- C1. Zadanie: Policz liczbę odbytych wizyt dla każdego lekarza.


SELECT
 o.imie,
 o.nazwisko,
 l.specjalizacja,
    
COUNT(w.id_wizyty) AS liczba_wizyt

FROM Lekarz l

JOIN Osoba o ON l.id_osoby = o.id_osoby

LEFT JOIN Wizyta w ON w.Lekarz_id_lekarza = l.id_lekarza
                  
AND w.Lekarz_id_osoby = l.id_osoby
                  
AND w.status = 'odbyta'

GROUP BY l.id_lekarza, l.id_osoby, o.imie, o.nazwisko, l.specjalizacja

ORDER BY liczba_wizyt DESC;



-- C2. Zadanie: Wyświetl oddziały, do których przypisanych
 jest więcej niż jeden lekarz. (HAVING)


SELECT
 od.nazwa AS oddzial,
    
COUNT(l.id_lekarza) AS liczba_lekarzy

FROM Oddzial od

LEFT JOIN Lekarz l ON od.id_oddzialu = l.id_oddzialu

GROUP BY od.id_oddzialu, od.nazwa

HAVING COUNT(l.id_lekarza) > 1

ORDER BY liczba_lekarzy DESC;



-- C3. Zadanie: Sprawdź, ile razy każdy lek pojawił się
 na receptach. Pokaż tylko leki przepisane więcej
 niż jeden raz. (HAVING)


SELECT
 lk.nazwa AS lek,
 
lk.forma,
    
COUNT(pr.id_recepty) AS liczba_przepisan

FROM Lek lk

JOIN Pozycja_Recepty pr ON lk.id_leku = pr.id_leku

GROUP BY lk.id_leku, lk.nazwa, lk.forma

HAVING COUNT(pr.id_recepty) > 1

ORDER BY liczba_przepisan DESC;



-- C4. Zadanie: Oblicz średni czas hospitalizacji w dniach
 dla każdego oddziału (tylko hospitalizacje zakończone).


SELECT
 od.nazwa AS oddzial,
    
COUNT(h.id_hospitalizacji) AS liczba_hospitalizacji,
    
AVG(h.data_wypisu - h.data_przyjecia) AS sredni_czas_dni

FROM Oddzial od

JOIN Sala_Szpitalna s ON od.id_oddzialu = s.id_oddzialu

JOIN Hospitalizacja h ON h.Szpitalna_id_sali = s.id_sali

WHERE h.status = 'zakonczona'

GROUP BY od.id_oddzialu, od.nazwa

ORDER BY sredni_czas_dni DESC;



-- C5. Zadanie: Policz liczbę recept wystawionych przez
 każdego lekarza. Pokaż tylko lekarzy, którzy wystawili
 więcej niż jedną receptę. (HAVING)


SELECT
 o.imie,
 o.nazwisko,
 l.specjalizacja,
 
COUNT(r.id_recepty) AS liczba_recept

FROM Lekarz  l

JOIN Osoba o ON l.id_osoby = o.id_osoby

JOIN Wizyta w ON w.Lekarz_id_lekarza = l.id_lekarza
               
AND w.Lekarz_id_osoby = l.id_osoby

JOIN Recepta r ON r.id_wizyty = w.id_wizyty

GROUP BY l.id_lekarza, l.id_osoby, o.imie, o.nazwisko, l.specjalizacja

HAVING COUNT(r.id_recepty) > 1

ORDER BY liczba_recept DESC;




-- D. POLECENIA SELECT Z PODZAPYTANIEM (5 zapytań,
 w tym 2 skorelowane oznaczone jako [SKORELOWANE])

-- D1. Zadanie: Wyświetl pacjentów, którzy byli hospitalizowani
 przynajmniej raz.

SELECT
 o.imie,
 o.nazwisko,
 o.PESEL,
 p.grupa_krwi

FROM Pacjent p

JOIN Osoba o ON p.id_osoby = o.id_osoby

WHERE p.id_pacjenta IN (
SELECT DISTINCT Pacjent_id_pacjenta
    
FROM Hospitalizacja
)

ORDER BY o.nazwisko;



-- D2. Zadanie: Wyświetl leki, których stan magazynowy
 jest niższy od średniego stanu wszystkich leków.


SELECT
 nazwa,
 substancja_czynna,
 stan_magazynowy,
 jednostka

FROM Lek

WHERE stan_magazynowy < (
SELECT AVG(stan_magazynowy)
    
FROM Lek
)

ORDER BY stan_magazynowy ASC;



-- D3. Zadanie: Wyświetl pacjentów, którzy mają aktualnie
 ważną receptę (data ważności >= dziś).


SELECT
 o.imie,
 o.nazwisko,
 o.telefon

FROM Pacjent p

JOIN Osoba o ON p.id_osoby = o.id_osoby

WHERE p.id_pacjenta IN (
SELECT DISTINCT w.Pacjent_id_pacjenta
    
FROM Recepta r
    
JOIN Wizyta w ON r.id_wizyty = w.id_wizyty
    
WHERE r.data_waznosci >= SYSDATE
)

ORDER BY o.nazwisko;



-- D4. [SKORELOWANE] Zadanie: Dla każdego pacjenta wyświetl
 datę jego ostatniej odbytej wizyty. Podzapytanie skorelowane w klauzuli SELECT.


SELECT
 o.imie,
 o.nazwisko,
 (
SELECT MAX(w.data)
        
FROM Wizyta w
        
WHERE w.Pacjent_id_pacjenta = p.id_pacjenta
          
AND w.Pacjent_id_osoby    = p.id_osoby
          
AND w.status = 'odbyta'
) AS data_ostatniej_wizyty

FROM Pacjent p

JOIN Osoba o ON p.id_osoby = o.id_osoby

ORDER BY data_ostatniej_wizyty DESC;



-- D5. [SKORELOWANE] Zadanie: Wyświetl lekarzy, którzy
 aktualnie prowadzą przynajmniej jednego
 hospitalizowanego pacjenta.
 Podzapytanie skorelowane w klauzuli WHERE z EXISTS.


SELECT
 o.imie,
 o.nazwisko,
 l.specjalizacja,
 
od.nazwa AS oddzial

FROM Lekarz l

JOIN Osoba o ON l.id_osoby = o.id_osoby

JOIN Oddzial od ON l.id_oddzialu = od.id_oddzialu

WHERE EXISTS (
SELECT 1
 FROM Hospitalizacja h
    
WHERE h.Lekarz_id_lekarza = l.id_lekarza
      
AND h.Lekarz_id_osoby = l.id_osoby
      
AND h.status = 'aktywna'
)

ORDER BY o.nazwisko;
