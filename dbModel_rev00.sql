-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- drop schema empsure;

CREATE SCHEMA IF NOT EXISTS empsure DEFAULT CHARACTER SET utf8 ;
USE empsure;

-- CREATE USER 'empsure'@'localhost' IDENTIFIED BY 'empsure';

GRANT ALL PRIVILEGES ON empsure.* TO 'empsure'@'localhost';

-- drop table usersure;

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
 -- INDEX fk_tbWage_tbEmployee1_idx (idEmployee ASC) VISIBLE,
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
 -- INDEX fk_tbFunction_tbEmployee1_idx (idEmployee ASC) VISIBLE,
 -- INDEX fk_tbFunction_tbFunctionType1_idx (idFunctionType ASC) VISIBLE,
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
--  INDEX fk_tbPosition_tbEmployee1_idx (idEmployee ASC) VISIBLE,
--  INDEX fk_tbPosition_tbPositionType1_idx (idPositionType ASC) VISIBLE,
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
--  INDEX fk_tbBonus_tbEmployee1_idx (idEmployee ASC) VISIBLE,
  CONSTRAINT fk_tbBonus_tbEmployee1
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbVacantionGrant
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbVacantionGrant (
  idVacationGrant INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  year INT NOT NULL,
  qtyDays INT NOT NULL,
  PRIMARY KEY (idVacationGrant),
--  INDEX fk_tbVacantionGrant_tbEmployee1_idx (idEmployee ASC) VISIBLE,
  CONSTRAINT fk_tbVacantionGrant_tbEmployee1
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table tbVacantionDate
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS tbVacantionDate (
  idVacationDate INT NOT NULL AUTO_INCREMENT,
  idEmployee INT NOT NULL,
  dateVacation DATE NOT NULL,
  status VARCHAR(1) NULL,
  PRIMARY KEY (idVacationDate),
--  INDEX fk_tbVacantionDates_tbEmployee1_idx (idEmployee ASC) VISIBLE,
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
  image VARCHAR(400) NOT NULL,
  typeImage VARCHAR(1) NOT NULL,
  date_time DATETIME NOT NULL,
  resultAuthentication FLOAT NULL,
  PRIMARY KEY (idImage),
 -- INDEX fk_tbImage_tbEmployee1_idx (idEmployee ASC) VISIBLE,
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
--  INDEX fk_tbDocument_tbEmployee1_idx (idEmployee ASC) VISIBLE,
--  INDEX fk_tbDocument_tbDocumentType1_idx (idDocumentType ASC) VISIBLE,
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
  tbEmployee_idEmployee INT NOT NULL,
  tbSiteOperation_idSiteOperation INT NOT NULL,
  initialDate DATE NOT NULL,
  finalDate DATE NULL,
  PRIMARY KEY (tbEmployee_idEmployee, tbSiteOperation_idSiteOperation),
--  INDEX fk_tbEmployee_has_tbSiteOperation_tbSiteOperation1_idx (tbSiteOperation_idSiteOperation ASC) VISIBLE,
--  INDEX fk_tbEmployee_has_tbSiteOperation_tbEmployee_idx (tbEmployee_idEmployee ASC) VISIBLE,
  CONSTRAINT fk_tbEmployee_has_tbSiteOperation_tbEmployee
    FOREIGN KEY (tbEmployee_idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_tbEmployee_has_tbSiteOperation_tbSiteOperation1
    FOREIGN KEY (tbSiteOperation_idSiteOperation)
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
--  INDEX fk_tbWage_tbEmployee1_idx (idEmployee ASC) VISIBLE,
  CONSTRAINT fk_tbWage_tbEmployee10
    FOREIGN KEY (idEmployee)
    REFERENCES tbEmployee (idEmployee)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
