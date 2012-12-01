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
