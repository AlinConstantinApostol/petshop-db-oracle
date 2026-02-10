-- =============================================================
-- SCRIPT TESTARE SI VALIDARE - PROIECT PETSHOP
-- =============================================================

-- =============================================================
-- A. VIZUALIZARE DATE (SELECT-uri cu JOIN)
-- Cerinta: Vizualizarea trebuie sa afiseze datele din mai multe tabele
-- =============================================================

-- 1. Raport Produse: Ce vindem, din ce categorie si la ce pret?
SELECT 
    c.nume_categorie AS "Categorie",
    p.cod_bare AS "Cod Produs",
    p.pret AS "Pret (RON)",
    p.cantitate AS "Stoc Disponibil"
FROM produse p
JOIN categorii_prod c ON p.categorie_id = c.categorie_id
ORDER BY c.nume_categorie;

-- 2. Raport Comenzi Detaliat: Cine a cumparat, cine a vandut si ce valoare?
SELECT 
    co.comanda_id AS "ID Comanda",
    TO_CHAR(co.data_comanda, 'DD-MM-YYYY') AS "Data",
    cli.nume || ' ' || cli.prenume AS "Client",
    CASE WHEN card.cod_card IS NOT NULL THEN 'DA (' || card.nivel_fidelitate || ')' ELSE 'NU' END AS "Are Card?",
    ang.nume || ' ' || ang.prenume AS "Casier",
    co.total_comanda AS "Total"
FROM comenzi co
JOIN clienti cli ON co.client_id = cli.client_id
JOIN angajati ang ON co.angajat_id = ang.angajat_id
LEFT JOIN carduri_fidelitate card ON cli.client_id = card.client_id;

-- =============================================================
-- B. VALIDARE CONSTRANGERI (Teste Negative)
-- Cerinta: Comentariu cu constrangerea testata si mesajul de eroare obtinut
-- =============================================================

-- 1. Testare PK (Primary Key)
-- Constrangere testata: Unicitatea ID-ului de categorie (categorii_prod_PK)
-- Mesaj eroare obtinut: ORA-00001: unique constraint (RO_B283_SQL_S19.CATEGORII_PROD_PK) violated
INSERT INTO categorii_prod (categorie_id, nume_categorie) VALUES (1, 'Dublura ID');

-- 2. Testare UK (Unique Key)
-- Constrangere testata: Unicitatea adresei de email (email_UK)
-- Mesaj eroare obtinut: ORA-00001: unique constraint (RO_B283_SQL_S19.EMAIL_UK) violated
INSERT INTO clienti (client_id, nume, prenume, email) 
VALUES (NULL, 'Test', 'Dublura', 'vlad.g@gmail.com');

-- 3. Testare CK (Check Constraint - Pret)
-- Constrangere testata: Pretul trebuie sa fie strict pozitiv (pret_ck)
-- Mesaj eroare obtinut: ORA-02290: check constraint (RO_B283_SQL_S19.PRET_CK) violated
INSERT INTO produse (produs_id, pret, cantitate, cod_bare, categorie_id) 
VALUES (NULL, -50, 10, 'TEST-NEGATIV', 1);

-- 4. Testare CK (Check Constraint - Regex Email)
-- Constrangere testata: Formatul emailului trebuie sa contina @ si domeniu
-- Mesaj eroare obtinut: ORA-02290: check constraint (RO_B283_SQL_S19.SYS_C0023997288) violated
INSERT INTO clienti (client_id, nume, prenume, email) 
VALUES (NULL, 'Test', 'Email', 'email_gresit.com');

-- 5. Testare FK (Foreign Key)
-- Constrangere testata: Clientul din comanda trebuie sa existe in tabela CLIENTI
-- Mesaj eroare obtinut: ORA-02291: integrity constraint (RO_B283_SQL_S19.CLIENTI_COMENZI_FK) violated - parent key not found
INSERT INTO comenzi (comanda_id, data_comanda, total_comanda, client_id, angajat_id) 
VALUES (NULL, SYSDATE, 50, 999, 2);

-- 6. Testare TRIGGER (Data Comanda)
-- Constrangere testata: Data comenzii nu poate fi in trecut (trg_comenzi_data)
-- Mesaj eroare obtinut: ORA-20002: Data comenzii invalida: [Data] trebuie sa fie cel putin data curenta.
INSERT INTO comenzi (comanda_id, data_comanda, total_comanda, client_id, angajat_id) 
VALUES (NULL, SYSDATE - 1, 100, 1, 2);

-- 7. Testare NN (Not Null)
-- Constrangere testata: Numele categoriei este obligatoriu (coloana nume_categorie are NOT NULL)
-- Mesaj eroare obtinut: ORA-01400: cannot insert NULL into ("RO_B283_SQL_S19"."CATEGORII_PROD"."NUME_CATEGORIE")
INSERT INTO categorii_prod (categorie_id, nume_categorie) 
VALUES (NULL, NULL);

-- 8. Testare Regula de Business (Max 10 unitati)
-- Cerinta: "Nu se pot vinde mai mult de 10 unitati din acelasi produs intr-o singura comanda"
-- Constrangere testata: CHECK pe tabela detalii_comanda
-- Mesaj eroare obtinut: ORA-02290: check constraint (RO_B283_SQL_S19.SYS_C0023997301) violated
INSERT INTO detalii_comanda (comanda_id, produs_id, cantitate_vand) 
VALUES (1, 4, 11);

