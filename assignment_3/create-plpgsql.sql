CREATE OR REPLACE FUNCTION bericht_verfasser_constraints() RETURNS trigger AS $$
	DECLARE
		ersteller	person%ROWTYPE;
		beteiligt	integer;
	BEGIN
		SELECT * INTO ersteller FROM person WHERE person.id = NEW.ersteller;
		SELECT count(*)
		INTO beteiligt
		FROM ereignis er
		JOIN einsatz ei ON ei.ereig_id = er.id
		JOIN mannschaft ma ON ma.id = ei.man_id
		JOIN person p ON p.mannschaft = ma.id
		WHERE er.id = NEW.ereignis_id
			AND p.id = NEW.ersteller;

		-- Ueberpruefung der Volljaehrigkeit zu Beginn des Einsatzes
		IF (NEW.datum < (ersteller.geburtstag + interval '18 years')) THEN
			RAISE EXCEPTION '% % (%) war am Einsatzbeginn noch nicht volljaehrig', ersteller.vorname, ersteller.nachname, ersteller.id;
		END IF;

		-- Ueberpruefung ob Ersteller im Einsatz beteiligt war
		IF (beteiligt = 0) THEN
			RAISE EXCEPTION '% % (%) war an diesem Einsatz nicht beteiligt', ersteller.vorname, ersteller.nachname, ersteller.id;
		END IF;

		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bericht_verfasser_constraints BEFORE INSERT OR UPDATE ON bericht
	FOR EACH ROW EXECUTE PROCEDURE bericht_verfasser_constraints();

-- ****************************************************************************** --

CREATE OR REPLACE FUNCTION einsatz_distinct() RETURNS trigger AS $$
	DECLARE
		result	    int;
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
			SELECT count(*)
			INTO result
			FROM einsatz
			WHERE ereig_id = NEW.ereig_id
				AND (fzg_id = NEW.fzg_id OR man_id = NEW.man_id)
				AND OLD.fzg_id <> fzg_id
				AND OLD.man_id <> man_id
			;
		ELSEIF true THEN
			SELECT count(*)
			INTO result
			FROM einsatz
			WHERE ereig_id = NEW.ereig_id
				AND (fzg_id = NEW.fzg_id OR man_id = NEW.man_id)
			;
		END IF;

		IF (result > 0) THEN
			RAISE EXCEPTION 'FZG % oder Mannschaft % bereits an diesem Einsatz beteiligt', NEW.fzg_id, NEW.man_id;
		END IF;

		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER einsatz_distinct BEFORE INSERT OR UPDATE ON einsatz
	FOR EACH ROW EXECUTE PROCEDURE einsatz_distinct();

CREATE OR REPLACE FUNCTION f_bonus (p_id integer) RETURNS NUMERIC(9,2) AS $$
	DECLARE
		p_count integer; -- Should be from {0,1} because of primary key
		summe NUMERIC(9,2);
	BEGIN
		SELECT count(id)
		INTO p_count
		FROM person
		WHERE id = p_id;

		IF p_count = 0 THEN
			RAISE EXCEPTION 'Person % nicht gefunden', p_id;
		END IF;

		WITH data AS (
			SELECT
				CASE platzierung
					WHEN 1 THEN 1.0
					WHEN 2 THEN 0.5
					WHEN 3 THEN 0.25
					ELSE 0.0
				END factor,
				wkt.sonderzahlung

			FROM person p
			JOIN pers_wktruppe pwt ON p.id = pwt.person_id
			JOIN wettkampftruppe wkt ON wkt.id = pwt.wktruppe_id
			JOIN wettkampf_teilnahme wkteil ON wkteil.wktruppe_id = wkt.id
			WHERE p.id = p_id
		)
		SELECT sum(factor * sonderzahlung)
		INTO summe
		FROM data;

		IF summe IS NOT NULL THEN
			RETURN summe;
		ELSE
			RETURN 0.0;
		END IF;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION p_erhoehe_dienstgrad (zeit integer)
	RETURNS void AS $$
	DECLARE
		candidates CURSOR FOR
			SELECT *
			FROM person p
			JOIN dienstgrad dg ON p.dienstgrad = dg.id
			WHERE age(dienstgrad_aenderung) >= (zeit::text || ' years')::interval
				AND dg.parent IS NOT NULL -- Ignoriere Personen, die bereits einen hiechsten Dienstrang haben
			FOR UPDATE;
		new_dienstgrad_bez dienstgrad.bezeichnung%TYPE;
	BEGIN
		IF zeit < 0 OR zeit IS NULL THEN
			RAISE EXCEPTION 'Der Parameter muss positiv sein';
		END IF;

		FOR p IN candidates LOOP
			UPDATE person
			SET dienstgrad = p.parent,
				dienstgrad_aenderung = CURRENT_DATE
			WHERE CURRENT OF candidates;

			SELECT bezeichnung
			INTO new_dienstgrad_bez
			FROM dienstgrad
			WHERE id = p.parent;

			RAISE NOTICE 'Person % % wurde befoerdert von % auf %', p.vorname, p.nachname, p.bezeichnung, new_dienstgrad_bez;
		END LOOP;

		RETURN;
	END
$$ LANGUAGE plpgsql
