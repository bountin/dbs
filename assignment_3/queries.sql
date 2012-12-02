SELECT m.id, m.rufname, l.id, l.nachname
FROM mannschaft m
JOIN person l ON m.leiter = l.id -- Leiter
WHERE (SELECT count(*) FROM bergefahrzeug) = (
	SELECT count(DISTINCT b.id)
	FROM einsatz
	JOIN bergefahrzeug b ON fzg_id = b.id
	WHERE man_id = m.id
	);

WITH RECURSIVE dienstgrade (id, bezeichnung, basisgehalt, parent, gehalt_diff) AS (
		SELECT *, 0::numeric
		FROM dienstgrad
		WHERE id = 4
	UNION ALL
		SELECT d.*, d.basisgehalt - ch.basisgehalt
		FROM dienstgrad d, dienstgrade ch
		WHERE ch.parent = d.id
)
SELECT id, bezeichnung, basisgehalt, gehalt_diff
FROM dienstgrade;

WITH berichte_pre AS (
	SELECT p.id, vorname, nachname, count(b.datum) as anz_b, (
		SELECT count(*)
		FROM einsatz e
		JOIN person pi ON pi.mannschaft = e.man_id
		WHERE pi.id = p.id
	) as anz_e
	FROM person p
	LEFT JOIN bericht b ON b.ersteller = p.id
	GROUP BY 1
),
berichte AS (
	SELECT *
	FROM berichte_pre
	WHERE anz_e < 3
)
SELECT id, vorname, nachname, anz_b
FROM berichte
WHERE anz_b = (SELECT min(anz_b) FROM berichte)
;
