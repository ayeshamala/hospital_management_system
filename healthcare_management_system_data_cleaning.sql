CREATE DATABASE healthcaremanagement;

-- --------------------------------------------------------------
-- ----------------- FEATURE ENGINEERING ------------------------
-- --------------------------------------------------------------

-- --------------------- appointment ----------------------------

-- changing data type of 'date'
UPDATE appointment
SET Date = STR_TO_DATE(Date, '%m/%d/%Y');

ALTER TABLE appointment MODIFY COLUMN Date DATE NOT NULL;

-- changing field name of AppointmentID
ALTER TABLE appointment CHANGE ï»¿AppointmentID AppointmentID DOUBLE NOT NULL;

-- dropping time column because it does not provide any value to the dataset
ALTER TABLE appointment DROP COLUMN Time;

-- Creating year, month, day, and weekday columns

ALTER TABLE appointment ADD COLUMN Year DOUBLE NOT NULL;

UPDATE appointment
SET year = YEAR(Date);

ALTER TABLE appointment ADD COLUMN Month VARCHAR(10) NOT NULL;

UPDATE appointment
SET Month = LEFT(MONTHNAME(Date), 3);

ALTER TABLE appointment ADD COLUMN Month_no DOUBLE NOT NULL;

UPDATE appointment
SET Month_no = MONTH(DATE);

ALTER TABLE appointment ADD COLUMN Weekday VARCHAR(10) NOT NULL;

UPDATE appointment
SET Weekday = LEFT(DAYNAME(Date), 3);

-- --------------------- billing ----------------------------
-- ----------------------------------------------------------

-- changing field name of InvoiceID
ALTER TABLE billing CHANGE ï»¿InvoiceID InvoiceID VARCHAR(255) NOT NULL;

-- changing data type of items to VARCHAR
ALTER TABLE billing MODIFY COLUMN Items VARCHAR(100) NOT NULL;

-- removing extra spaces from Items and InvoiceID

UPDATE billing
SET Items = TRIM(Items);

UPDATE billing
SET InvoiceID = TRIM(InvoiceID);

-- replace empty Items rows with 'Not Applicable'

UPDATE billing
SET Items = 'Not Applicable'
WHERE Items = '';

ALTER TABLE billing MODIFY COLUMN Items VARCHAR(100) NOT NULL;

-- --------------------- doctor -----------------------------
-- ----------------------------------------------------------

-- changing field name of DoctorID
ALTER TABLE doctor CHANGE ï»¿DoctorID DoctorID DOUBLE NOT NULL;

-- new column 'email' in 'doctor' table
ALTER TABLE doctor ADD COLUMN firstname VARCHAR(20) NOT NULL;

ALTER TABLE doctor MODIFY COLUMN DoctorName VARCHAR(20) NOT NULL;

UPDATE doctor
SET firstname = LOWER(DoctorName);

ALTER TABLE doctor ADD COLUMN Email VARCHAR(100) NOT NULL;

UPDATE doctor
SET DoctorContact = SUBSTRING(DoctorContact, 2);

UPDATE doctor
SET Email = CONCAT(firstname, DoctorContact);

-- changing data type of Specialization and DoctorContact columns

ALTER TABLE doctor MODIFY COLUMN Specialization VARCHAR(100) NOT NULL;
ALTER TABLE doctor MODIFY COLUMN DoctorContact VARCHAR(50) NOT NULL;

-- deleting unnecessary tables

ALTER TABLE doctor DROP COLUMN firstname;
ALTER TABLE doctor DROP COLUMN DoctorContact;

-- adding prefix to doctor names
UPDATE doctor
SET DoctorName = CONCAT('Dr. ', DoctorName);
-- --------------------- med_procedure ----------------------------
-- ----------------------------------------------------------------

-- changing field name of ProcedureID

ALTER TABLE med_procedure CHANGE ï»¿ProcedureID ProcedureID DOUBLE NOT NULL;

-- updating data types in med_procedure

ALTER TABLE med_procedure MODIFY COLUMN ProcedureName VARCHAR(100) NOT NULL;

-- --------------------- patient ----------------------------
-- ----------------------------------------------------------

-- changing field name of PatientID
ALTER TABLE patient CHANGE ï»¿PatientID PatientID DOUBLE NOT NULL;

-- updating data types in 'patient' 

ALTER TABLE patient MODIFY COLUMN firstname VARCHAR(50) NOT NULL;
ALTER TABLE patient MODIFY COLUMN lastname VARCHAR(50) NOT NULL;
ALTER TABLE patient MODIFY COLUMN email VARCHAR(100) NOT NULL;

-- changing case of email in 'patient'
UPDATE patient
SET email = LOWER(email);

-- adding a new full name column to 'patient'
ALTER TABLE patient ADD COLUMN FullName VARCHAR(50) NOT NULL;

UPDATE patient
SET FullName = CONCAT(firstname, ' ', lastname);

-- capitalizing the lowercase column names in 'patient'

ALTER TABLE patient CHANGE FIRSTNAME FirstName VARCHAR(50) NOT NULL;
ALTER TABLE patient CHANGE lastname LastName VARCHAR(50) NOT NULL;
ALTER TABLE patient CHANGE email Email VARCHAR(100) NOT NULL;



