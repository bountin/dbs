CREATE TABLE bergefahrzeug (
    id integer NOT NULL,
    max_zugleistung integer NOT NULL,
    hebevorrichtung boolean NOT NULL
);
CREATE TABLE bericht (
    ereignis_id integer NOT NULL,
    bericht_nummer integer NOT NULL,
    ersteller integer NOT NULL,
    kurzbeschreibung text NOT NULL,
    datum date NOT NULL
);
CREATE TABLE dienstgrad (
    id integer NOT NULL,
    bezeichnung text NOT NULL,
    -- Mehr als 9.9 Mio wird ein Feuerwehrmann schon nicht verdienen
    basisgehalt numeric(9,2) NOT NULL,
    parent integer,
    CONSTRAINT positives_gehalt CHECK (basisgehalt >= 0)
);
CREATE TABLE einsatz (
    fzg_id integer NOT NULL,
    man_id integer NOT NULL,
    ereig_id integer NOT NULL
);
CREATE TABLE ereignis (
    id integer NOT NULL,
    typ text NOT NULL,
    ort text NOT NULL,
    zeitpunkt timestamp NOT NULL,
    betroffene_personen integer NOT NULL,
    CONSTRAINT typ_liste CHECK (typ IN ('Brand', 'Verkehrsunfall', 'Hochwasser', 'Sonstiges'))
);
CREATE TABLE fahrzeug (
    id integer NOT NULL,
    sitzplaetze integer NOT NULL,
    gewicht integer NOT NULL,
    modell text NOT NULL,
    baujahr date NOT NULL
);
CREATE SEQUENCE fahrzeug_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE fahrzeug_id_seq OWNED BY fahrzeug.id;
CREATE TABLE loeschfahrzeug (
    id integer NOT NULL,
    hauptloeschmittel text NOT NULL,
    loeschmittelmenge integer NOT NULL
);
CREATE TABLE mannschaft (
    id integer NOT NULL,
    rufname text NOT NULL,
    leiter integer NOT NULL
);
CREATE SEQUENCE mannschaft_id_seq
    START WITH 10
    INCREMENT BY 10
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE mannschaft_id_seq OWNED BY mannschaft.id;
CREATE TABLE pers_wktruppe (
    person_id integer NOT NULL,
    wktruppe_id integer NOT NULL,
    funktion text NOT NULL
);
CREATE TABLE person (
    id integer NOT NULL,
    vorname text NOT NULL,
    nachname text NOT NULL,
    geburtstag date NOT NULL,
    beitrittstag date NOT NULL,
    telefon text NOT NULL,
    mannschaft integer NOT NULL,
    dienstgrad integer NOT NULL,
    dienstgrad_aenderung date NOT NULL,
    CONSTRAINT dienstgrad_aendung_nach_beitritt CHECK (dienstgrad_aenderung >= beitrittstag)
);
CREATE TABLE wettkampf (
    id integer NOT NULL,
    ort text NOT NULL,
    veranstalter text NOT NULL,
    kategorie text NOT NULL,
    von timestamp NOT NULL,
    bis timestamp NOT NULL
);
CREATE TABLE wettkampf_teilnahme (
    wktruppe_id integer NOT NULL,
    wettkampf_id integer NOT NULL,
    platzierung integer NOT NULL
);
CREATE TABLE wettkampftruppe (
    id integer NOT NULL,
    gruendung date NOT NULL,
    kategorie text NOT NULL,
    sonderzahlung text NOT NULL,
    CONSTRAINT gruendung_in_vergangenheit CHECK (gruendung <= CURRENT_DATE)
);
ALTER TABLE ONLY fahrzeug ALTER COLUMN id SET DEFAULT nextval('fahrzeug_id_seq'::regclass);
ALTER TABLE ONLY mannschaft ALTER COLUMN id SET DEFAULT nextval('mannschaft_id_seq'::regclass);
ALTER TABLE ONLY bergefahrzeug
    ADD CONSTRAINT bergefahrzeug_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bericht
    ADD CONSTRAINT bericht_pkey PRIMARY KEY (ereignis_id, bericht_nummer);
ALTER TABLE ONLY dienstgrad
    ADD CONSTRAINT dienstgrad_pkey PRIMARY KEY (id);
ALTER TABLE ONLY einsatz
    ADD CONSTRAINT einsatz_pkey PRIMARY KEY (fzg_id, man_id, ereig_id);
ALTER TABLE ONLY ereignis
    ADD CONSTRAINT ereignis_pkey PRIMARY KEY (id);
ALTER TABLE ONLY fahrzeug
    ADD CONSTRAINT fahrzeug_pkey PRIMARY KEY (id);
ALTER TABLE ONLY loeschfahrzeug
    ADD CONSTRAINT loeschfahrzeug_pkey PRIMARY KEY (id);
ALTER TABLE ONLY mannschaft
    ADD CONSTRAINT mannschaft_pkey PRIMARY KEY (id);
ALTER TABLE ONLY pers_wktruppe
    ADD CONSTRAINT pers_wktruppe_pkey PRIMARY KEY (person_id, wktruppe_id);
ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);
ALTER TABLE ONLY wettkampf
    ADD CONSTRAINT wettkampf_pkey PRIMARY KEY (id);
ALTER TABLE ONLY wettkampf_teilnahme
    ADD CONSTRAINT wettkampf_teilnahme_pkey PRIMARY KEY (wktruppe_id, wettkampf_id);
ALTER TABLE ONLY wettkampftruppe
    ADD CONSTRAINT wettkampftruppe_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bergefahrzeug
    ADD CONSTRAINT bergefahrzeug_id_fkey FOREIGN KEY (id) REFERENCES fahrzeug(id);
ALTER TABLE ONLY bericht
    ADD CONSTRAINT bericht_ereignis_id_fkey FOREIGN KEY (ereignis_id) REFERENCES ereignis(id);
ALTER TABLE ONLY bericht
    ADD CONSTRAINT bericht_ersteller_fkey FOREIGN KEY (ersteller) REFERENCES person(id);
ALTER TABLE ONLY dienstgrad
    ADD CONSTRAINT dienstgrad_parent_fkey FOREIGN KEY (parent) REFERENCES dienstgrad(id);
ALTER TABLE ONLY einsatz
    ADD CONSTRAINT einsatz_ereig_id_fkey FOREIGN KEY (ereig_id) REFERENCES ereignis(id);
ALTER TABLE ONLY einsatz
    ADD CONSTRAINT einsatz_fzg_id_fkey FOREIGN KEY (fzg_id) REFERENCES fahrzeug(id);
ALTER TABLE ONLY einsatz
    ADD CONSTRAINT einsatz_man_id_fkey FOREIGN KEY (man_id) REFERENCES mannschaft(id);
ALTER TABLE ONLY loeschfahrzeug
    ADD CONSTRAINT loeschfahrzeug_id_fkey FOREIGN KEY (id) REFERENCES fahrzeug(id);
ALTER TABLE ONLY mannschaft
    ADD CONSTRAINT mannschaft_leiter_fkey FOREIGN KEY (leiter) REFERENCES person(id) DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY pers_wktruppe
    ADD CONSTRAINT pers_wktruppe_person_id_fkey FOREIGN KEY (person_id) REFERENCES person(id);
ALTER TABLE ONLY pers_wktruppe
    ADD CONSTRAINT pers_wktruppe_wktruppe_id_fkey FOREIGN KEY (wktruppe_id) REFERENCES wettkampftruppe(id);
ALTER TABLE ONLY person
    ADD CONSTRAINT person_dienstgrad_fkey FOREIGN KEY (dienstgrad) REFERENCES dienstgrad(id);
ALTER TABLE ONLY person
    ADD CONSTRAINT person_mannschaft_fkey FOREIGN KEY (mannschaft) REFERENCES mannschaft(id) DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE ONLY wettkampf_teilnahme
    ADD CONSTRAINT wettkampf_teilnahme_wettkampf_id_fkey FOREIGN KEY (wettkampf_id) REFERENCES wettkampf(id);
ALTER TABLE ONLY wettkampf_teilnahme
    ADD CONSTRAINT wettkampf_teilnahme_wktruppe_id_fkey FOREIGN KEY (wktruppe_id) REFERENCES wettkampftruppe(id);
