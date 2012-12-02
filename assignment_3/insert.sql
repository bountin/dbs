--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: fahrzeug_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('fahrzeug_id_seq', 10, true);


--
-- Name: mannschaft_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('mannschaft_id_seq', 30, true);

BEGIN;

--
-- Data for Name: fahrzeug_modell; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO fahrzeug_modell (id, marke, modell) VALUES (1, 'VW', 'KommandoFZG');
INSERT INTO fahrzeug_modell (id, marke, modell) VALUES (2, 'VW', 'LoeschFZG1');
INSERT INTO fahrzeug_modell (id, marke, modell) VALUES (3, 'BMW', 'LoeschFZG2');
INSERT INTO fahrzeug_modell (id, marke, modell) VALUES (4, 'Audi', 'BergeFZG');
INSERT INTO fahrzeug_modell (id, marke, modell) VALUES (5, 'Toyota', 'UeberFZG');


--
-- Data for Name: fahrzeug; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO fahrzeug (id, sitzplaetze, gewicht, modell, baujahr) VALUES (1, 4, 1234, 1, '1990-01-01');
INSERT INTO fahrzeug (id, sitzplaetze, gewicht, modell, baujahr) VALUES (2, 4, 1234, 2, '1990-01-01');
INSERT INTO fahrzeug (id, sitzplaetze, gewicht, modell, baujahr) VALUES (3, 4, 1234, 3, '1990-01-01');
INSERT INTO fahrzeug (id, sitzplaetze, gewicht, modell, baujahr) VALUES (4, 4, 1234, 2, '1990-01-01');
INSERT INTO fahrzeug (id, sitzplaetze, gewicht, modell, baujahr) VALUES (5, 4, 1234, 4, '1990-01-01');
INSERT INTO fahrzeug (id, sitzplaetze, gewicht, modell, baujahr) VALUES (9, 4, 1234, 5, '1990-01-01');
INSERT INTO fahrzeug (id, sitzplaetze, gewicht, modell, baujahr) VALUES (10, 4, 1234, 5, '1990-01-01');


--
-- Data for Name: bergefahrzeug; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO bergefahrzeug (id, max_zugleistung, hebevorrichtung) VALUES (5, 123, true);
INSERT INTO bergefahrzeug (id, max_zugleistung, hebevorrichtung) VALUES (9, 123, true);
INSERT INTO bergefahrzeug (id, max_zugleistung, hebevorrichtung) VALUES (10, 123, true);


--
-- Data for Name: dienstgrad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO dienstgrad (id, bezeichnung, basisgehalt, parent) VALUES (1, 'Oberster', 35, NULL);
INSERT INTO dienstgrad (id, bezeichnung, basisgehalt, parent) VALUES (2, 'Mittlerer', 25, 1);
INSERT INTO dienstgrad (id, bezeichnung, basisgehalt, parent) VALUES (3, 'Unterer 1', 10, 2);
INSERT INTO dienstgrad (id, bezeichnung, basisgehalt, parent) VALUES (4, 'Unterer 2', 10, 2);


--
-- Data for Name: ereignis; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO ereignis (id, typ, ort, zeitpunkt, betroffene_personen) VALUES (1, 'Brand', 'Tulln', '2012-03-14 00:00:00', 55);
INSERT INTO ereignis (id, typ, ort, zeitpunkt, betroffene_personen) VALUES (2, 'Brand', 'Tulln', '2012-03-14 00:00:00', 55);
INSERT INTO ereignis (id, typ, ort, zeitpunkt, betroffene_personen) VALUES (3, 'Brand', 'Tulln', '2012-03-14 00:00:00', 55);


--
-- Data for Name: mannschaft; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO mannschaft (id, rufname, leiter) VALUES (10, 'A-Team', 1);
INSERT INTO mannschaft (id, rufname, leiter) VALUES (20, 'B-Team', 4);
INSERT INTO mannschaft (id, rufname, leiter) VALUES (30, 'C-Team', 5);
INSERT INTO mannschaft (id, rufname, leiter) VALUES (40, 'D-Team', 6);


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO person (id, vorname, nachname, geburtstag, beitrittstag, telefon, mannschaft, dienstgrad, dienstgrad_aenderung) VALUES (1, 'M', 'P', '1990-12-31', '2000-01-01', '+43 123', 10, 1, '2001-04-07');
INSERT INTO person (id, vorname, nachname, geburtstag, beitrittstag, telefon, mannschaft, dienstgrad, dienstgrad_aenderung) VALUES (2, 'L', 'P', '1992-12-22', '2000-01-01', '+43 123', 10, 2, '2001-04-07');
INSERT INTO person (id, vorname, nachname, geburtstag, beitrittstag, telefon, mannschaft, dienstgrad, dienstgrad_aenderung) VALUES (3, 'E', 'P', '1992-01-03', '2000-01-01', '+43 123', 10, 2, '2001-04-07');
INSERT INTO person (id, vorname, nachname, geburtstag, beitrittstag, telefon, mannschaft, dienstgrad, dienstgrad_aenderung) VALUES (4, 'wer', 'auch immer', '1988-01-01', '2000-01-01', '+43 123', 20, 3, '2001-04-07');
INSERT INTO person (id, vorname, nachname, geburtstag, beitrittstag, telefon, mannschaft, dienstgrad, dienstgrad_aenderung) VALUES (5, 'wer', 'auch immer', '1988-01-01', '2000-01-01', '+43 123', 30, 3, '2001-04-07');
INSERT INTO person (id, vorname, nachname, geburtstag, beitrittstag, telefon, mannschaft, dienstgrad, dienstgrad_aenderung) VALUES (6, 'ABC', 'DEF', '1988-01-01', '2000-01-01', '+43 123', 40, 3, '2001-04-07');
INSERT INTO person (id, vorname, nachname, geburtstag, beitrittstag, telefon, mannschaft, dienstgrad, dienstgrad_aenderung) VALUES (7, 'ABC', 'DEF', '1988-01-01', '2000-01-01', '+43 123', 40, 3, '2001-04-07');


--
-- Data for Name: bericht; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO bericht (ereignis_id, bericht_nummer, ersteller, kurzbeschreibung, datum) VALUES (1, 1, 1, 'foo', '2012-05-06');
INSERT INTO bericht (ereignis_id, bericht_nummer, ersteller, kurzbeschreibung, datum) VALUES (1, 2, 1, 'foo', '2012-05-06');
INSERT INTO bericht (ereignis_id, bericht_nummer, ersteller, kurzbeschreibung, datum) VALUES (1, 3, 6, 'foo', '2012-05-06');


--
-- Data for Name: einsatz; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO einsatz (fzg_id, man_id, ereig_id) VALUES (5, 10, 1);
INSERT INTO einsatz (fzg_id, man_id, ereig_id) VALUES (3, 20, 2);
INSERT INTO einsatz (fzg_id, man_id, ereig_id) VALUES (4, 30, 3);
INSERT INTO einsatz (fzg_id, man_id, ereig_id) VALUES (9, 10, 2);
INSERT INTO einsatz (fzg_id, man_id, ereig_id) VALUES (10, 10, 3);
INSERT INTO einsatz (fzg_id, man_id, ereig_id) VALUES (9, 20, 3);
INSERT INTO einsatz (fzg_id, man_id, ereig_id) VALUES (10, 20, 1);
INSERT INTO einsatz (fzg_id, man_id, ereig_id) VALUES (1, 30, 1);
INSERT INTO einsatz (fzg_id, man_id, ereig_id) VALUES (2, 40, 1);


--
-- Data for Name: loeschfahrzeug; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO loeschfahrzeug (id, hauptloeschmittel, loeschmittelmenge) VALUES (2, 'loeschmittel', 123);
INSERT INTO loeschfahrzeug (id, hauptloeschmittel, loeschmittelmenge) VALUES (3, 'loeschmittel', 123);
INSERT INTO loeschfahrzeug (id, hauptloeschmittel, loeschmittelmenge) VALUES (4, 'loeschmittel', 123);
INSERT INTO loeschfahrzeug (id, hauptloeschmittel, loeschmittelmenge) VALUES (9, 'loeschmittel', 1235);
INSERT INTO loeschfahrzeug (id, hauptloeschmittel, loeschmittelmenge) VALUES (10, 'loeschmittel', 1235);


--
-- Data for Name: wettkampftruppe; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO wettkampftruppe (id, gruendung, kategorie, sonderzahlung) VALUES (1, '2012-01-01', 'whatever', 24.12);
INSERT INTO wettkampftruppe (id, gruendung, kategorie, sonderzahlung) VALUES (2, '2012-01-01', 'whatever', 24.12);
INSERT INTO wettkampftruppe (id, gruendung, kategorie, sonderzahlung) VALUES (3, '2012-01-01', 'whatever', 24.12);


--
-- Data for Name: pers_wktruppe; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO pers_wktruppe (person_id, wktruppe_id, funktion) VALUES (1, 1, 'hanswurst');
INSERT INTO pers_wktruppe (person_id, wktruppe_id, funktion) VALUES (2, 1, 'hanswurst');
INSERT INTO pers_wktruppe (person_id, wktruppe_id, funktion) VALUES (3, 1, 'hanswurst');
INSERT INTO pers_wktruppe (person_id, wktruppe_id, funktion) VALUES (4, 1, 'hanswurst');
INSERT INTO pers_wktruppe (person_id, wktruppe_id, funktion) VALUES (5, 1, 'hanswurst');


--
-- Data for Name: wettkampf; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO wettkampf (id, ort, veranstalter, kategorie, von, bis) VALUES (1, 'Wiese', 'Raika', 'Bogenschießen', '2012-11-01 14:00:00', '2012-11-01 19:00:00');
INSERT INTO wettkampf (id, ort, veranstalter, kategorie, von, bis) VALUES (2, 'Wiese', 'Raika', 'Bogenschießen', '2012-11-01 14:00:00', '2012-11-01 19:00:00');
INSERT INTO wettkampf (id, ort, veranstalter, kategorie, von, bis) VALUES (3, 'Wiese', 'Raika', 'Bogenschießen', '2012-11-01 14:00:00', '2012-11-01 19:00:00');


--
-- Data for Name: wettkampf_teilnahme; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO wettkampf_teilnahme (wktruppe_id, wettkampf_id, platzierung) VALUES (1, 1, 1);
INSERT INTO wettkampf_teilnahme (wktruppe_id, wettkampf_id, platzierung) VALUES (2, 1, 2);
INSERT INTO wettkampf_teilnahme (wktruppe_id, wettkampf_id, platzierung) VALUES (3, 1, 3);


--
-- PostgreSQL database dump complete
--

COMMIT;
