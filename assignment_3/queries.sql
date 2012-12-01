SELECT m.id, m.rufname, l.id, l.nachname
FROM mannschaft m
JOIN person l ON m.leiter = l.id -- Leiter
WHERE (SELECT count(*) FROM bergefahrzeug) = (
	SELECT count(DISTINCT b.id)
	FROM einsatz
	JOIN bergefahrzeug b ON fzg_id = b.id
	WHERE man_id = m.id
	);
