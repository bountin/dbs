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
