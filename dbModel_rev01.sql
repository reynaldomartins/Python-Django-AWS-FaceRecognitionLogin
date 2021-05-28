-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS empsure DEFAULT CHARACTER SET 'utf8mb4' ;
USE empsure;


-- CREATE USER 'empsure'@'localhost' IDENTIFIED BY 'empsure';
GRANT ALL PRIVILEGES ON empsure.* TO 'empsure'@'localhost';


-- -----------------------------------------------------
-- Table tbEmployee
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbEmployee (
  idEmployee INT NOT NULL AUTO_INCREMENT,
  firstName VARCHAR(45) NOT NULL,
  lastName VARCHAR(45) NOT NULL,
  birthDate DATE NOT NULL,
  contractInitialDate DATE NOT NULL,
  contractFinalDate DATE NULL,
  PRIMARY KEY (idEmployee));

-- -----------------------------------------------------
-- Table tbWage
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbWage (
  idWage INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  wageValue DECIMAL(10,2) NOT NULL,
  initialDate DATE NOT NULL,
  finalDate DATE NULL,
  PRIMARY KEY (idWage),
  CONSTRAINT fk_tbWage_tbEmployee1
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbFunctionType
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbFunctionType (
  idFunctionType INT NOT NULL AUTO_INCREMENT,
  functionType VARCHAR(45) NOT NULL,
  description VARCHAR(400) NULL,
  PRIMARY KEY (idFunctionType));

-- -----------------------------------------------------
-- Table tbFunction
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbFunction (
  idFunction INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  idFunctionType INT NOT NULL,
  initialDate DATE NOT NULL,
  finalDate DATE NULL,
  PRIMARY KEY (idFunction),
  CONSTRAINT fk_tbFunction_tbEmployee1
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_tbFunction_tbFunctionType1
    FOREIGN KEY (idFunctionType)
    REFERENCES tbFunctionType (idFunctionType)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbPositionType
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbPositionType (
  idPositionType INT NOT NULL AUTO_INCREMENT,
  positionType VARCHAR(45) NOT NULL,
  description VARCHAR(400) NULL,
  PRIMARY KEY (idPositionType));

-- -----------------------------------------------------
-- Table tbPosition
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbPosition (
  idPosition INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  idPositionType INT NOT NULL,
  initialDate DATE NOT NULL,
  finalDate DATE NULL,
  statusRH TINYINT NULL,
  PRIMARY KEY (idPosition),
  CONSTRAINT fk_tbPosition_tbEmployee1
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_tbPosition_tbPositionType1
    FOREIGN KEY (idPositionType)
    REFERENCES tbPositionType (idPositionType)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbBonus
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbBonus (
  idBonus INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  bonusValue DECIMAL(10,2) NOT NULL,
  bonusDate DATE NOT NULL,
  PRIMARY KEY (idBonus),
  CONSTRAINT fk_tbBonus_tbEmployee1
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbVacationGrant
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbVacationGrant (
  idVacationGrant INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  year INT NOT NULL,
  qtyDays INT NOT NULL,
  PRIMARY KEY (idVacationGrant),
  CONSTRAINT fk_tbVacantionGrant_tbEmployee1
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbVacantionDate
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbVacationDate (
  idVacationDate INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  dateVacation DATE NOT NULL,
  status VARCHAR(1) NULL,
  PRIMARY KEY (idVacationDate),
  CONSTRAINT fk_tbVacantionDates_tbEmployee1
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbImage
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbImage (
  idImage INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  nameImage VARCHAR(400) NOT NULL,
  typeImage VARCHAR(1) NOT NULL,
  date_time DATETIME NOT NULL,
  resultAuthentication FLOAT NULL,
  PRIMARY KEY (idImage),
  CONSTRAINT fk_tbImage_tbEmployee1
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbDocumentType
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbDocumentType (
  idDocumentType INT NOT NULL AUTO_INCREMENT,
  type VARCHAR(20) NOT NULL,
  description VARCHAR(400) NOT NULL,
  PRIMARY KEY (idDocumentType));

-- -----------------------------------------------------
-- Table tbDocument
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbDocument (
  idDocument INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  idDocumentType INT NOT NULL,
  nameDocument VARCHAR(400) NOT NULL,
  date_time DATETIME NOT NULL,
  title VARCHAR(100) NULL,
  comment VARCHAR(400) NULL,
  PRIMARY KEY (idDocument),
  CONSTRAINT fk_tbDocument_tbEmployee1
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_tbDocument_tbDocumentType1
    FOREIGN KEY (idDocumentType)
    REFERENCES tbDocumentType (idDocumentType)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbSiteOperation
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbSiteOperation (
  idSiteOperation INT NOT NULL AUTO_INCREMENT,
  city VARCHAR(45) NOT NULL,
  country VARCHAR(45) NOT NULL,
  description VARCHAR(400) NULL,
  PRIMARY KEY (idSiteOperation));

-- -----------------------------------------------------
-- Table tbEmployeeSiteOperation
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbEmployeeSiteOperation (
  idEmployee INT NOT NULL,
  idSiteOperation INT NOT NULL,
  initialDate DATE NOT NULL,
  finalDate DATE NULL,
  PRIMARY KEY (idEmployee, idSiteOperation),
  CONSTRAINT fk_tbEmployee_has_tbSiteOperation_tbEmployee
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_tbEmployee_has_tbSiteOperation_tbSiteOperation1
    FOREIGN KEY (idSiteOperation)
    REFERENCES tbSiteOperation (idSiteOperation)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbPayment
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbPayment (
  idPayment INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  grossPayment DECIMAL(10,2) NOT NULL,
  discounts DECIMAL(10,2) NOT NULL,
  paymentDate DATE NOT NULL,
  PRIMARY KEY (idPayment),
  CONSTRAINT fk_tbWage_tbEmployee10
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- DATA INSERTION
-- -----------------------------------------------------
INSERT INTO tbEmployee (firstName, lastName, birthDate, contractInitialDate, contractFinalDate) VALUES ('Reynaldo', 'Martins', '1970-06-01', '1999-05-01', NULL); 		#1
INSERT INTO tbEmployee (firstName, lastName, birthDate, contractInitialDate, contractFinalDate) VALUES ('Ronaldo', 'Oliveira', '1976-08-17', '1999-06-15', NULL); 		#2
INSERT INTO tbEmployee (firstName, lastName, birthDate, contractInitialDate, contractFinalDate) VALUES ('John', 'Watson', '1978-11-10', '2002-02-10', '2017-05-10'); 	#3
INSERT INTO tbEmployee (firstName, lastName, birthDate, contractInitialDate, contractFinalDate) VALUES ('Mary', 'Sears', '1985-02-18', '2007-02-01', NULL); 			#4

INSERT INTO tbFunctionType (functionType, description) VALUES ("Operations Manager", "Responsible for operations and production");		#1
INSERT INTO tbFunctionType (functionType, description) VALUES ("Drill Expert", "Responsible for performing the drills");				#2
INSERT INTO tbFunctionType (functionType, description) VALUES ("Financial Manager", "Responsible for financial decisions");				#3
INSERT INTO tbFunctionType (functionType, description) VALUES ("Driver", "Responsible for driving the company's vehicles");				#4
INSERT INTO tbFunctionType (functionType, description) VALUES ("Secretary", "Responsible for supporting administrative activities");	#5

INSERT INTO tbPositionType (positionType, description) VALUES ("Oil Engineer", "Specialist of oil or petrolium issues");				#1
INSERT INTO tbPositionType (positionType, description) VALUES ("Administrator", "Administration skills");								#2
INSERT INTO tbPositionType (positionType, description) VALUES ("Technician", "Offshore skills");										#3
INSERT INTO tbPositionType (positionType, description) VALUES ("Geophysicist", "Geomodeling and support offshore");						#4

INSERT INTO tbFunction (idEmployee, idFunctionType, initialDate, finalDate) VALUES (1, 2, '1999-05-01', '2010-11-10');
INSERT INTO tbFunction (idEmployee, idFunctionType, initialDate, finalDate) VALUES (1, 3, '2010-11-11', NULL);
INSERT INTO tbFunction (idEmployee, idFunctionType, initialDate, finalDate) VALUES (2, 4, '1999-06-15', '2012-01-20');
INSERT INTO tbFunction (idEmployee, idFunctionType, initialDate, finalDate) VALUES (2, 1, '2012-01-21', NULL);
  
INSERT INTO tbPosition (idEmployee, idPositionType, initialDate, finalDate) VALUES (1, 3, '1999-05-01', '2010-11-10');
INSERT INTO tbPosition (idEmployee, idPositionType, initialDate, finalDate) VALUES (1, 2, '2010-11-11', NULL);
INSERT INTO tbPosition (idEmployee, idPositionType, initialDate, finalDate) VALUES (2, 3, '1999-06-15', '2012-01-20');
INSERT INTO tbPosition (idEmployee, idPositionType, initialDate, finalDate) VALUES (2, 4, '2012-01-21', NULL);

INSERT INTO tbBonus (idemployee, bonusValue, bonusDate) VALUES (1, 5000, '2015-06-01');
INSERT INTO tbBonus (idemployee, bonusValue, bonusDate) VALUES (1, 6000, '2018-12-01');
INSERT INTO tbBonus (idemployee, bonusValue, bonusDate) VALUES (2, 3000, '2013-08-21');
INSERT INTO tbBonus (idemployee, bonusValue, bonusDate) VALUES (2, 7000, '2017-02-28');
INSERT INTO tbBonus (idemployee, bonusValue, bonusDate) VALUES (3, 2000, '2018-12-21');
INSERT INTO tbBonus (idemployee, bonusValue, bonusDate) VALUES (4, 1000, '2018-06-01');

INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-04-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-04-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-05-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-05-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-06-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-06-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-07-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-07-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-08-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-08-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-09-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (1, 4000, 1000, '2020-09-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 3500,  850, '2020-04-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 3500,  850, '2020-04-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 3800,  900, '2020-05-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 3800,  900, '2020-05-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 3900,  950, '2020-06-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 3900,  950, '2020-06-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 4000, 1000, '2020-07-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 4000, 1000, '2020-07-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 4000, 1000, '2020-08-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 4000, 1000, '2020-08-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 4000, 1000, '2020-09-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (2, 4000, 1000, '2020-09-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (4, 2000,  500, '2020-08-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (4, 2000,  500, '2020-08-30');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (4, 2000,  500, '2020-09-15');
INSERT INTO tbPayment (idemployee, grossPayment, discounts, paymentDate) VALUES (4, 2000,  500, '2020-09-30');

INSERT INTO tbWage (idemployee, wageValue, initialDate, finalDate) VALUES (1, 30.00, '2010-01-01', '2012-12-31');
INSERT INTO tbWage (idemployee, wageValue, initialDate, finalDate) VALUES (1, 35.00, '2013-01-01', '2014-12-31');
INSERT INTO tbWage (idemployee, wageValue, initialDate, finalDate) VALUES (1, 40.00, '2015-01-01', '2017-12-31');
INSERT INTO tbWage (idemployee, wageValue, initialDate, finalDate) VALUES (1, 50.00, '2018-01-01', NULL);
INSERT INTO tbWage (idemployee, wageValue, initialDate, finalDate) VALUES (2, 25.00, '2010-06-01', '2013-05-31');
INSERT INTO tbWage (idemployee, wageValue, initialDate, finalDate) VALUES (2, 30.00, '2013-06-01', '2015-06-30');
INSERT INTO tbWage (idemployee, wageValue, initialDate, finalDate) VALUES (2, 42.00, '2015-07-01', '2018-07-31');
INSERT INTO tbWage (idemployee, wageValue, initialDate, finalDate) VALUES (2, 55.00, '2018-08-01', NULL);
INSERT INTO tbWage (idemployee, wageValue, initialDate, finalDate) VALUES (4, 20.00, '2007-12-01', '2015-07-31');
INSERT INTO tbWage (idemployee, wageValue, initialDate, finalDate) VALUES (4, 25.00, '2015-08-01', NULL);

INSERT INTO tbSiteOperation (city, country, description) VALUES ('Houston', 'USA', 'Golf of Mexico - operation with Halliburton');
INSERT INTO tbSiteOperation (city, country, description) VALUES ('Macaé', 'Brazil', 'Petrobras operations shared');
INSERT INTO tbSiteOperation (city, country, description) VALUES ('Dubai', 'UAE', 'Exploration and refining');
INSERT INTO tbSiteOperation (city, country, description) VALUES ('Ras Tanura', 'Saudi Arabia', 'Support and pipeline operations');

INSERT INTO tbEmployeeSiteOperation (idEmployee, idSiteOperation, initialDate, finalDate) VALUES (1, 3, '2009-01-01', '2015-11-30');
INSERT INTO tbEmployeeSiteOperation (idEmployee, idSiteOperation, initialDate, finalDate) VALUES (1, 2, '2015-12-01', '2017-04-09');
INSERT INTO tbEmployeeSiteOperation (idEmployee, idSiteOperation, initialDate, finalDate) VALUES (1, 1, '2017-04-10', NULL);
INSERT INTO tbEmployeeSiteOperation (idEmployee, idSiteOperation, initialDate, finalDate) VALUES (2, 4, '2008-01-25', '2013-10-22');
INSERT INTO tbEmployeeSiteOperation (idEmployee, idSiteOperation, initialDate, finalDate) VALUES (2, 3, '2013-10-23', '2018-02-14');
INSERT INTO tbEmployeeSiteOperation (idEmployee, idSiteOperation, initialDate, finalDate) VALUES (2, 1, '2018-02-15', NULL);

INSERT INTO tbDocumentType (type, description) VALUES ('Parecer', 'Technical Evaluation');
INSERT INTO tbDocumentType (type, description) VALUES ('Report', 'Technical Report');
INSERT INTO tbDocumentType (type, description) VALUES ('Demonstration', 'As-built');
INSERT INTO tbDocumentType (type, description) VALUES ('Medical Certificate', "Medical document about the employee's health");

INSERT INTO tbDocument (idemployee, iddocumenttype, namedocument, date_time, title, comment) VALUES (1, 2, 'Exploration and perfuration', '2009-05-11 22:15:00', 'Technical Considerations', NULL);
INSERT INTO tbDocument (idemployee, iddocumenttype, namedocument, date_time, title, comment) VALUES (2, 4, 'Check-up', '2017-01-07 10:10:15', 'Blood Results', NULL);

INSERT INTO tbVacationGrant (idemployee, year, qtyDays) VALUES (1, 2017, 20);
INSERT INTO tbVacationGrant (idemployee, year, qtyDays) VALUES (1, 2018, 15);
INSERT INTO tbVacationGrant (idemployee, year, qtyDays) VALUES (1, 2019, 15);
INSERT INTO tbVacationGrant (idemployee, year, qtyDays) VALUES (2, 2017, 15);
INSERT INTO tbVacationGrant (idemployee, year, qtyDays) VALUES (2, 2018, 18);
INSERT INTO tbVacationGrant (idemployee, year, qtyDays) VALUES (2, 2019, 12);

INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (1, '2017-04-15', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (1, '2017-07-05', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (1, '2018-02-25', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (1, '2018-06-13', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (1, '2018-07-01', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (1, '2018-11-05', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (1, '2019-04-14', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (1, '2019-06-18', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (1, '2019-09-23', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (2, '2017-04-15', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (2, '2017-04-17', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (2, '2017-01-25', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (2, '2018-08-23', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (2, '2018-08-07', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (2, '2019-09-15', 'A');
INSERT INTO tbVacationDate (idemployee, dateVacation, status) VALUES (2, '2019-05-17', 'A');
