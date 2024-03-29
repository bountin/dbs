
--
-- Test fuer Ueberpruefung, dass Person Volljaehrig sein muss
--
-- Person 1 = M P, mit Geburtstag 31.12.2012
--

BEGIN;

-- Cleanup
DELETE FROM bericht WHERE ereignis_id = 1 AND bericht_nummer IN (4,5);
SAVEPOINT init;

-- Erwarte Exception:
INSERT INTO bericht (ereignis_id, bericht_nummer, ersteller, kurzbeschreibung, datum)
	VALUES (1, 4, 1, 'x', '2008-12-30');
ROLLBACK TO init;
INSERT INTO bericht (ereignis_id, bericht_nummer, ersteller, kurzbeschreibung, datum)
	VALUES (1, 4, 1, 'x', '1900-01-01');
ROLLBACK TO init;

-- Funktioniert:
INSERT INTO bericht (ereignis_id, bericht_nummer, ersteller, kurzbeschreibung, datum)
    VALUES (1, 4, 1, 'x', '2008-12-31');
INSERT INTO bericht (ereignis_id, bericht_nummer, ersteller, kurzbeschreibung, datum)
	VALUES (1, 5, 1, 'x', '2012-01-01');

ROLLBACK;


--
-- Test fuer Ueberpruefung, dass nur am Einsatz beteiligte Personen den Bericht schreiben duerfen
--
-- Mannschaft 10: P 1,2,3
-- Mannschaft 20: P 4
-- Mannschaft 30: P 5
-- Ereignis (1,2,3) <=> Mannschaft (10,20,30)
--

BEGIN;

-- Cleanup
DELETE FROM bericht;
SAVEPOINT init;

-- Erwartete Exception:
INSERT INTO bericht (ereignis_id, bericht_nummer, ersteller, kurzbeschreibung, datum)
	VALUES (1, 1, 4, 'x', '2012-01-01');
ROLLBACK TO init;

-- Funktioniert:
INSERT INTO bericht (ereignis_id, bericht_nummer, ersteller, kurzbeschreibung, datum)
	VALUES (1, 1, 3, 'x', '2012-01-01');

ROLLBACK;

--
-- Test fuer Ueberpruefung, dass bei einem festen Einsatz die Mannschaft und das Fahrzeug distikt sein muessen
--
-- Einsatz fix 1
--

BEGIN;

-- Cleanup
DELETE FROM einsatz WHERE ereig_id = 1;
SAVEPOINT init;

-- INSERT PART
-- Okay
INSERT INTO einsatz (ereig_id, fzg_id, man_id)
	VALUES (1, 1, 10);
INSERT INTO einsatz (ereig_id, fzg_id, man_id)
	VALUES (1, 2, 20);
SAVEPOINT prepared;

-- Trigger Exceptions:
INSERT INTO einsatz (ereig_id, fzg_id, man_id)
	VALUES (1, 2, 20);
ROLLBACK TO prepared;
INSERT INTO einsatz (ereig_id, fzg_id, man_id)
	VALUES (1, 2, 30);
ROLLBACK TO prepared;
INSERT INTO einsatz (ereig_id, fzg_id, man_id)
	VALUES (1, 3, 20);
ROLLBACK TO prepared;

-- UPDATE PART
-- Okay:
UPDATE einsatz
SET man_id = 30
WHERE ereig_id = 1
	AND fzg_id = 1
	AND man_id = 10;

UPDATE einsatz
SET fzg_id = 3
WHERE ereig_id = 1
	AND fzg_id = 1
	AND man_id = 30;

-- changing nothing should work
UPDATE einsatz
SET fzg_id = 3
WHERE ereig_id = 1
	AND fzg_id = 3
	AND man_id = 30;

ROLLBACK TO PREPARED;

-- Exceptions:
UPDATE einsatz
SET fzg_id = 1
WHERE ereig_id = 1
	AND fzg_id = 2
	AND man_id = 20;
ROLLBACK TO prepared;

UPDATE einsatz
SET man_id = 10
WHERE ereig_id = 1
	AND fzg_id = 2
	AND man_id = 20;
ROLLBACK TO prepared;

UPDATE einsatz
SET man_id = 1, fzg_id = 1
WHERE ereig_id = 1
	AND fzg_id = 2
	AND man_id = 20;
ROLLBACK TO prepared;

ROLLBACK;

--
-- Test f_bonus
--

BEGIN;
DELETE FROM wettkampf_teilnahme;
DELETE FROM pers_wktruppe;
DELETE FROM wettkampftruppe;
SAVEPOINT init;

-- Exceptions:
SELECT f_bonus(-1);
ROLLBACK TO init;

-- Real stuff:
INSERT INTO wettkampftruppe (id, gruendung, kategorie, sonderzahlung) VALUES
	(10, '2012-01-01', 'whatever', 1000.00),
	(11, '2012-01-01', 'whatever', 500.0);
INSERT INTO pers_wktruppe (person_id, wktruppe_id, funktion) VALUES
	(1, 10, ''),
	(2, 10, ''),
	(3, 11, '');

SELECT f_bonus(1) = 0.0 as result; -- Keine Teilnahmen, kein Bonus

INSERT INTO wettkampf_teilnahme (wktruppe_id, wettkampf_id, platzierung) VALUES
	(10, 1, 5);
SELECT f_bonus(1) = 0.0 as result; -- Teilnahme, aber eine unzureichende Platzierung

INSERT INTO wettkampf_teilnahme (wktruppe_id, wettkampf_id, platzierung) VALUES
	(10, 2, 1);
SELECT f_bonus(1) = 1000.0 as result;

INSERT INTO wettkampf_teilnahme (wktruppe_id, wettkampf_id, platzierung) VALUES
	(10, 3, 3);
SELECT f_bonus(1) = 1250.0 as result;

ROLLBACK;

--
-- Test p_erhoehe_dienstgrad
--
BEGIN;

-- Exception:
SELECT p_erhoehe_dienstgrad(-1);
ROLLBACK; BEGIN;

-- Okay:
SELECT * FROM person ORDER BY id;
SELECT p_erhoehe_dienstgrad(1);
SELECT * FROM person ORDER BY id;
SELECT p_erhoehe_dienstgrad(1);
SELECT * FROM person ORDER BY id;

ROLLBACK;
