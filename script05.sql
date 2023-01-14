# SOURCE C:/Users/ALEXANDRU HOMOSAPIEN/Desktop/BD/script05.sql

/*#############################################################*/

/*        PARTEA 1 - STERGEREA SI RECREAREA BAZEI DE DATE      */

CREATE DATABASE magazinDB;
USE magazinDB;

/*#############################################################*/

/*#############################################################*/

/*                  PARTEA 2 - CREAREA TABELELOR              */

CREATE TABLE tblFurnizori(
	idFurnizori SMALLINT NOT NULL PRIMARY KEY,
	numeFurnizor VARCHAR(50) NOT NULL,
	NrInmatriculareFurnizor VARCHAR(50),
	judetFurnizor VARCHAR(50),
	adresaFurnizor VARCHAR(50),
	emailFurnizor VARCHAR(50),
	telefonFurnizor CHAR(10)
);

CREATE TABLE tblDepartament(
 idDepartament SMALLINT PRIMARY KEY,
 numeDepartament VARCHAR (50) NOT NULL,
 categorieDepartament VARCHAR (50),
 sezon VARCHAR(50)
 );
 
 CREATE TABLE tblAngajati(
	id_angajat SMALLINT NOT NULL PRIMARY KEY AUTO_INCREMENT  ,
	nume VARCHAR(50) NOT NULL,
	functie VARCHAR(50),
	expir_contr_date DATE,
	salariu INT(8)
);

CREATE TABLE tblFacturi(
	idFactura SMALLINT(5) PRIMARY KEY, 
	idAngajat  SMALLINT NOT NULL,    
	valoareFactura DECIMAL(10,2), 
	dataFacturarii DATE,
	CONSTRAINT fk_angajat FOREIGN KEY (idAngajat)
    REFERENCES tblAngajati(id_angajat) ON DELETE CASCADE ON UPDATE CASCADE
); 

CREATE TABLE tblInventar(
	idProdus SMALLINT NOT NULL PRIMARY KEY,
	furnizor SMALLINT NOT NULL,
	departament SMALLINT NOT NULL,
	numeProdus VARCHAR(50) NOT NULL,
	nota VARCHAR (50) NOT NULL,
	pret DECIMAL(10,2) NOT NULL ,
	cantitate SMALLINT(6) NOT NULL,
	CONSTRAINT fk_furnizor FOREIGN KEY (furnizor)
	REFERENCES tblFurnizori (idFurnizori) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_departament FOREIGN KEY (departament)
	REFERENCES tblDepartament (idDepartament) ON DELETE CASCADE ON UPDATE CASCADE
	);
	
 CREATE TABLE tblDetaliiFacturi(
	id_Factura SMALLINT(5) ,
	id_Produs SMALLINT NOT NULL ,
	cantitateProdus SMALLINT,
	pretProdus DECIMAL(10,2),
	CONSTRAINT fk_factura FOREIGN KEY (id_Factura)
    REFERENCES tblFacturi(idFactura) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_produs FOREIGN KEY (id_Produs)
    REFERENCES tblInventar(idProdus) ON DELETE CASCADE ON UPDATE CASCADE 
);

SHOW TABLES;

/*#############################################################*/

/*#############################################################*/

/*         PARTEA 3 - INSERAREA INREGISTRARILOR IN TABELE      */

 -- INSERARI FURNIZORI
INSERT INTO tblFurnizori 
VALUES 
	(1, "Ottorose Rom", "J29/890/2002", "Prahova", "Bulevardul REPUBLICII nr. 301", "account@ottorose.ro", "244433835"),
	(2, "Romanita SA","J40/12100/2020", "Caracal", "Strada Vornicu Ureche nr.2", "office@romanitasa.ro", "0787207507"),
	(3, "Braiconf SA","J09/5/1991", "Braila", "Strada Scolilor nr.53", "intern@braiconf.ro", "0239692200"),
	(4, "Texdata SRL", "J39/196/2002", "Vrancea", "Strada Cotesti 109", "lsolomon@texdata.ro", "0237232071"),
	(5, "Pandora Prod","J39/1466/1994", "Vrancea", "Strada Cuza Voda 73", "office@pandora-prod.ro", "0237238135"),
	(6, "Formens SRL","J07/233/1999", "Botosani", "Calea Nationala 30C", "sales.mtm@formens.ro", "0790180799"),
	(7, "Simiz Fashion SRL", "J39/384/2014", "Vrancea", "Strada Suraii Simiz", "office@simizfashion.ro", "0237222478"),
	(8, "NICOLIS PRODCOM SRL", "J33/2213/1994", "Suceava", "Strada Victoriei 17", "yly.nicolis@yahoo.com", "0230412424"),
	(9, "MOPIEL SRL", "J10/135/2002", "Buzau", "Sat Podgoria", "info@incaltaminte-mopiel.ro" ,"0238406242"),
	(10, "GINO ROSSI PRODUCTION SRL", "J40/22475/1994", "Bucuresti", "Strada Splaiul Unirii 160A", "office@ginorossi.ro", "0371183744"),
	(11, "ARA SHOES ROMANIA SRL", "J05/1446/1997", "Bihor", "Calea Revolutiei 82", "ara-romania@ara-shoes.de", "0259406000"),
	(12, "MUSETTE EXIM SRL", "J40/8273/1992", "Bucuresti", "Strada Alexandru Donici 2", "office@musettegroup.ro", "0213306525"),
	(13, "LEONARDO SHOES & ACCESORII SRL", "J30/160/2017", "Satu Mare", "Strada Stefan Octavian Iosif 6", "berende.berende@yahoo.ro", "0261716789"),
	(14, "EUROFINA SRL", "J38/316/2003", "Valcea", "Strada Tudor Vladimirescu 723", "info@eurofina.ro", "0250830005"),
	(15, "DENIS SHOES SRL", "J33/2207/1994", "Suceava", "Calea Unirii 20", "contact@denis-shoes.ro", "0230551586");

-- INSERARI DEPARTAMENT
INSERT INTO tblDepartament 
VALUES 
	(1, "Femei", "Imbracaminte", "Rece"),
	(2, "Femei", "Imbracaminte", "Cald" ),
	(3, "Femei", "Incaltaminte", "Rece" ),
	(4, "Femei", "Incaltaminte", "Cald" ),
	(5, "Femei", "Accesorii", "Universal"),
	
	(6, "Barbat", "Imbracaminte", "Rece"),
	(7, "Barbat", "Imbracaminte", "Cald" ),
	(8, "Barbat", "Incaltaminte", "Rece" ),
	(9, "Barbat", "Incaltaminte", "Cald" ),
	(10, "Barbat", "Accesorii", "Universal"),
	
	(11, "Copii", "Imbracaminte", "Rece"),
	(12, "Copii", "Imbracaminte", "Cald" ),
	(13, "Copii", "Incaltaminte", "Rece" ),
	(14, "Copii", "Incaltaminte", "Cald" ),
	(15, "Copii", "Accesorii", "Universal");

-- INSERARI ANGAJATI
INSERT INTO tblAngajati(nume, functie, expir_contr_date, salariu ) 
VALUES 
	("Chifu Gabriel", "Ingrijitor",'2023-03-12', 2000 ),
	("Florea Iulian", "Paznic",'2024-01-19', 2300 ),
	("Popescu Gabriel", "Casier", '2023-06-04', 2500 ),
	("Stan Alexandru", "Casier", '2023-08-17', 2700 ),
	("Munteanu Ovidiu", "Casier", '2024-04-11', 2600 ),
	("Dobric Carla", "Casier", '2023-05-01', 2400 ),
	("Florescu Gabriela", "Manager Magazin", '2027-07-20', 7200 ),
	("Ionescu Bogdan", "Asistent Manager", '2026-11-23', 5600 ),
	("Craciun Roberta", "Contabil", '2026-10-22', 4800 ),
	("Chirila Corina", "HR", '2027-02-02', 3600 );

-- INSERARI INVENTAR
-- Barbati
INSERT INTO tblInventar(idProdus,furnizor,departament, numeProdus, nota, pret, cantitate) 
VALUES 
	(1,12,6, " Pulover ", "Bleumarin/Merry Christmoose", 89.99, 3), 
	(2,1,7, " Bluza de molton Relaxed Fit cu imprimeu ", "Mov-deschis/Coca-cola ", 129.99, 20), 
	(3,1,7, " Pantaloni cargo tip jogging ", "Negru", 129.99, 7 ), 
	(4,1,6, " Jacheta de schi din puf ","Negru", 799.99, 42), 
	(5,1,7, " Slim Jeans ", "Albastru-denmin deschis", 109.99, 50), 
	(6,2, 10, " Caciula cu clape peste urechi ", "Negru", 79.99, 82), 
	(7,2, 10, " Set de 2 piese cu papion si bretele", "Verde/omuleti de turta dulce", 59.99, 23), 
	(8,2, 10, " Cravata de satin ", "Negru", 39.99, 41),
	(9,2, 10, " Set de sport ", "Negru", 89.99,32),
	(10,3, 10, " Curea de piele ", "Negru", 79.99, 76),
	(11,3, 10, " Ochelari de soare polarizati ", "Argintiu", 79.99, 68),
	(12,3, 8, " Ghete Chelsea ", "Negru", 199.99, 90),
	(13,3, 9, " Pantofi sport de panza ", "Alb", 89.99, 65),
	(14,14,10, " Caciula cu barba ", "Rosu", 39.99, 22),
	(15,14,8, " Ghete Chelsea din piele intoarsa ", "Negru", 299.99, 76),
	(16,14, 7, " Pantaloni jogging Regular Fit ", "Verde-kaki", 89.99, 32),
	(17,3, 9, " Pantofi sport fara sireturi ", "Negru", 89.99, 39),
	(18,3, 6, " Jacheta supradimensionata vatuita ", "Verde-kaki", 349.99, 32),
	(19,2, 8, " Ghete Chelsea cu talpa groasa ", "Negru", 229.99, 86),
	(20,3, 9, " Pantofi sport fara sireturi ", "Gri", 89.99, 32),
	(67,1,6, " Hanorac de plus Relaxed Fit", "Negru", 159.99, 99),
-- Femei
	(21,13, 2, " Rochie mulata drapata ","Bej-deschis/ cu motive",129.99, 33), 
	(22,4,1, " Bluza tricotata cu guler rulat ","Negru", 59.99, 41), 
	(23,4,2, " Camasa din amestec de bumbac ", "Alb", 79.99, 33), 
	(24,4,1, " Hanorac supradimensionat","Negru", 99.99, 21), 
	(25,4,1, " Pulover fin cu guler rulat", "Alb", 59.99, 10), 
	(26,5,5, " Caciula reiata din mix de lana", "Alb", 59.99, 20), 
	(27,5,5, " Rhinestone-chain headpiece ","Argintiu", 199.99, 42), 
	(28,5,3, " Ghete sport vatuite ", "Bej-deschis", 159.99, 53),
	(29,5,2, " Skinny High Jeans ", "Negru", 89.99, 28),
	(30,6,3, " Ghete calduroase ", "Negru", 59.99, 87),
	(31,6,3, " Ghete Chelsea cu platforma", "Negru", 159.99, 78),
	(32,6,4, " Sandale tip slapi ", "Bej", 39.99, 102),
	(33,6,4, " Pantofi escarpen cu lant cu strasuri ", "Fucsia", 139.99, 52),
	(34,7,5, " Cercei lungi cu strasuri ", "Argintiu", 59.99, 123),
	(35,7,5, " Colier scurt cu strasuri ", "Argintiu", 129.99, 32),
	(36,7,5, " Fular cu franjuri ", "Alb", 59.99, 22),
	(37,15,2, " Rochie-sacou cu doua randuri de nasturi ", "Negru", 159.99, 87),
	(38,15,2, " Bluza de molton ", "Bej-deschis", 39.99, 55),
	(39,15,5, " Geanta shopper ", "Negru", 129.99, 68),
	(40,6, 4, " Balerini cu varful ascutit", "Taupe-inchis", 89.99, 39),
 -- Copii
	( 41,14, 11, " Bluza de molton cu imprimeu ", "Vanilie/Hogwarts", 39.99, 21), 
	(42,8,11, " Jacheta hidrofuga THERMOLITE ", "Portocaliu ", 139.99, 87), 
	(43,8,15, " Rucsac cu imprimeu ", "Rosu-inchis/Harry Potter", 129.99, 65), 
	(44,8,15, " Caciula tricotata din fir plusat", "Mov", 39.99, 21),
	(45,8,13, " Ghete calduroase ", "Black", 129.99, 123), 
	(46,9,14, " Pantofi sport inalti imperpeabili ", "Maro/negru", 199.99, 32),
	(47,9,12, " Salopeta cu imprimeu ", "Albastru/motiv de Craciun", 139.99, 28),
	(48,9,12, " Pantaloni tip jogging ", "Bej/culori bloc", 89.99, 56),
	(49,9,12, " Pijama in carouri ", "Bleumarin/carouri", 89.99, 66),
	(50,10,13, " Papuci moi in forma de hamburger ", "Maro-deschis/hamburger", 79.99, 35),
	(51,10,15, " Curea ", "Negru", 39.99, 67),
	(52,10,11, " Pulover de bumbac tricotat fin ", "Gri-deschis melanj", 59.99, 38),
	(53,9, 14, " Pantofi sport inalti ", "Negru/alb", 129.99, 76),
	(54,11, 12, " Rochie si caciula de Craciun", "Verde/spiridus", 89.99, 54), 
	(55,11, 13, " Ghete vatuite ", "Negru", 99.99, 23),
	(56,11, 11, " Set de 2 piese", "Rosu/You & Me", 99.99, 91),
	(57,11, 15, " Appliqued rib-knit hat", "Verde-inchis/Harry Potter", 39.99, 28),
	(58,11, 15, " Clame si agrafa de par", "Rosu/in carouri", 22.99, 34),
	(59,12, 13, " Ghete Chelsea ", "Black", 139.99, 27),
	(60,12, 11, " Vesta vatuita ", "Roz-bej inchis", 89.99, 89),
	(61,12, 12, " Body cu guler ", "Rosu", 34.99, 86),
	(62,12, 11, " Jacheta de baseball supradimensionata", "Negru/Always Care", 99.99, 66),
	(63,13, 12, " Pijama de bumbac pentru frate/sora ", "Mov/Big Sis", 69.99, 44),
	(64,13, 11, " Papuci pufosi ", "Mov-deschis", 59.99, 43),
	(65,13, 15, " Umbrela cu imprimeu ", "Rosu/Omul-Paianjen", 29.99, 33),
	(66,9, 14, " Pantofi sport inalti ", "Taupe/alb-natur", 129.99, 89);

-- INSERARI FACTURI
INSERT INTO tblFacturi(idFactura, idAngajat, valoareFactura, dataFacturarii ) 
VALUES 
	(1, 3, 1159.97, '2022-03-13'),
	(2, 4, 439.94, '2022-11-19'),
	(3, 5, 59.99, '2022-10-18'),
	(4, 6, 779.9, '2022-06-12'),
	(5, 7, 339.93, '2022-09-29'),
	(6, 8, 1009.87, '2022-08-02'),
	(7, 9, 1309.87, '2022-08-05'),
	(8, 3, 569.93, '2022-11-19'),
	(9, 4, 839.94, '2022-11-13'),
	(10, 5, 1051.86, '2022-10-15');

-- INSERARI DETALII FACTURI
INSERT INTO tblDetaliiFacturi(id_Factura, id_Produs, cantitateProdus, pretProdus) 
VALUES
	(1, 4, 1, 799.99), (1, 12, 1, 199.99), (1, 37, 1, 159.99),
	(2, 17, 2, 89.99), (2, 25, 3, 59.99), (2, 50, 1, 79.99),
	(3, 30, 1, 59.99),
	(4, 43, 1, 129.99), (4, 38, 2, 39.99), (4, 63, 3, 69.99), (4, 13, 4, 89.99),
	(5, 56, 1, 99.99), (5, 51, 6, 39.99),
	(6, 3, 3, 129.99), (6, 64, 1, 59.99), (6, 26, 8, 59.99), (6, 10, 1, 79.99),
	(7, 16, 7, 89.99), (7, 11, 2, 79.99), (7, 39, 4, 129.99),
	(8, 29, 1, 89.99), (8, 24, 7, 79.99),
	(9, 42, 6, 139.99),
	(10, 55, 1, 99.99), (10, 37, 1, 159.99), (10, 52, 7, 55.99), (10, 23, 5, 79.55);
	
/*#############################################################*/

/*  PARTEA 4 - VIZUALIZAREA STUCTURII BD SI A INREGISTRARILOR  */

DESCRIBE tblFurnizori;
DESCRIBE tblDepartament; 
DESCRIBE tblAngajati;
DESCRIBE tblInventar;	
DESCRIBE tblFacturi;	
DESCRIBE tblDetaliiFacturi;

SELECT *FROM tblFurnizori;
SELECT *FROM  tblDepartament;
SELECT *FROM tblAngajati;
SELECT *FROM tblInventar; 
SELECT *FROM tblFacturi;
SELECT *FROM tblDetaliiFacturi;

/*#############################################################*/