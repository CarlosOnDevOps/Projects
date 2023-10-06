/* 
Carlos M.
NOV 28, 2022
The purpose of this database is to improve standardization of all records associated with a functioning hospital 
*/

CREATE DATABASE HMS;
USE HMS;
----------------------------------------------
--              TABLES HERE
----------------------------------------------
CREATE TABLE Patient(
    Name varchar(255) NOT NULL,
    Email varchar(255) NOT NULL,
    Password varchar(255) NOT NULL,
    Address varchar(255) NOT NULL,
    Gender varchar(255) NOT NULL,
    PRIMARY KEY (Name)
);

CREATE TABLE MedicalHistory(
    MHId INT,
    Date Date NOT NULL,
    Conditions varchar(255) NOT NULL,
    Surgeries varchar(255) NOT NULL,
    Medication varchar(255) NOT NULL,
    PRIMARY KEY (MHId)
);

CREATE TABLE Doctor(
    Name varchar(255) NOT NULL,
    Email varchar(255) NOT NULL,
    Password varchar(24) NOT NULL,
    Gender varchar(24) NOT NULL,
    PRIMARY KEY (Email)
);

CREATE TABLE Appointment(
    ApptId INT NOT NULL,
    Date DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Status varchar(24) NOT NULL,
    PRIMARY KEY (ApptId)
);

CREATE TABLE Schedule(
    ScheduleId INT NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    BreakTime TIME NOT NULL,
    Day varchar(24) NOT NULL,
    PRIMARY KEY (ScheduleId, StartTime, EndTime, BreakTime, day)
);

CREATE TABLE PatientsAttendAppointments(
    PatientID INT NOT NULL,
    Appointment INT NOT NULL,
    Concerns varchar(255) NOT NULL,
    Symptoms varchar(255) NOT NULL,
    PRIMARY KEY (PatientID, Appointment)
    FOREIGN KEY PatientID REFERENCES Patient.Email ON DELETE CASCADE,
    FOREIGN KEY Appointment REFERENCES Appointment.ApptId,
);

CREATE TABLE DocsHaveSchedules(
   ScheduleId INT NOT NULL, 
   Doctor varchar(255) NOT NULL,
   PRIMARY KEY (ScheduleId),
   FOREIGN KEY ScheduleId REFERENCES Schedule.ScheduleId ON DELETE CASCADE,
   FOREIGN KEY Doctor REFERENCES Doctor.Email ON DELETE CASCADE
);

CREATE TABLE PatientsFillHistory(
    PatientId INT NOT NULL,
    History INT NOT NULL,
    PRIMARY KEY (History),
    FOREIGN KEY PatientID REFERENCES Patient.Email ON DELETE CASCADE,
    FOREIGN KEY History REFERENCES MedicalHistory.MHId ON DELETE CASCADE
);

CREATE TABLE Diagnose(
    AppointmentId INT NOT NULL,
    Doctor varchar(255) NOT NULL,
    Diagnosis varchar(255) NOT NULL,
    Prescription varchar(255) NOT NULL,
    PRIMARY KEY (AppointmentId, Doctor),
    FOREIGN KEY AppointmentId REFERENCES Appointment.ApptId ON DELETE CASCADE,
    FOREIGN KEY Doctor REFERENCES Doctor.Email
);

CREATE TABLE DoctorViewsHistory(
    History INT NOT NULL,
    Doctor varchar(255) NOT NULL,
    PRIMARY KEY (History, Doctor)
    FOREIGN KEY Doctor REFERENCES Doctor.Email,
    FOREIGN KEY History REFERENCES MedicalHistory.MHId
);
----------------------------------------------
--              END TABLES
----------------------------------------------


/* TIme to start adding values to the tables */
----------------------------------------------
--              VALUES
----------------------------------------------
INSERT INTO Patient(Name, Email, Password, Address, Gender)
VALUES
    ('Bart Simpson', 'bart.simpson@gmail.com', 'doh!', '742 Evergreen Terrace', 'Male'),
    ('Homer Simpson', 'homer.simpson@gmail.com', 'doh!', '742 Evergreen Terrace', 'Male'),
    ('Lisa Simpson', 'lisa.simpson@gmail.com', 'doh!', '742 Evergreen Terrace', 'Female');

INSERT INTO MedicalHistory(MHId, Date, Conditions, Surgeries, Medication)
VALUES
    (1, '11-28-22', 'Fractured throat', 'Neck Surgery', 'Cough Drops'),
    (2, '11-28-22', 'Pain when using brain to think', 'Brain Surgery', 'Experimental donuts')
    (3, '11-28-22', 'Dry lips', 'No Surgeries', 'Donut flavored lip balm');

INSERT INTO Doctor(Name, Email, Password, Gender)
VALUES
    ('Julius Hibbert', 'jhibbert@gmail.com', 'appleaday', 'Male')
    ('Nick Riviera', 'nriviera@gmail.com', 'appleaday', 'Male');

INSERT INTO Appointment(ApptId, StartTime, EndTime, Status)
VALUES
    (1, '19-01-15', '09:00', '10:00', 'Done'),
    (2, '19-01-16', '10:00', '11:00', 'Done'),
    (3, '19-01-18', '14:00', '15:00', 'Done');

INSERT INTO PatientsAttendAppointments(PatientID, Appointment, Concerns, Symptoms)
VALUES
    ('bart.simpson@gmail.com',1, 'none', 'itchy throat'),
    ('homer.simpson@gmail.com',2, 'forgetfullness', 'headache'),
    ('lisa.simpson@gmail.com',3, 'dry lips', 'high thirst');

INSERT INTO Schedule(ScheduleId, StartTime, EndTime, BreakTime, Day)
VALUES
    (001,'09:00','17:00','12:00','Tuesday'),
    (001,'09:00','17:00','12:00','Friday'),
    (001,'09:00','17:00','12:00','Saturday'),
    (001,'09:00','17:00','12:00','Sunday'),
    (002,'09:00','17:00','12:00','Wednesday'),
    (002,'09:00','17:00','12:00','Friday');

INSERT INTO PatientsFillHistory(PatientID, Appointment)
VALUES
    ('bart.simpson@gmail.com', 1),
    ('homer.simpson@gmail.com', 2),
    ('lisa.simpson@gmail.com', 3);

INSERT INTO Diagnose(AppointmentId, Doctor, Diagnosis, Prescription)
VALUES
    (1,'nriviera@gmail.com', 'Bloating', 'Ibuprofen as needed'),
    (2,'nriviera@gmail.com', 'Muscle soreness', 'Stretch morning/night'),
    (3,'nriviera@gmail.com', 'Vitamin Deficiency', 'Good Diet');

INSERT INTO DocsHaveSchedules(ScheduleId, Doctor)
VALUES
    (001,'nriviera@gmail.com'),
    (002,'nriviera@gmail.com');

INSERT INTO DoctorViewsHistory(History, Doctor)
VALUES
    (1,'nriviera@gmail.com'),
    (2,'nriviera@gmail.com'),
    (3,'nriviera@gmail.com');
----------------------------------------------
--              END VALUES
----------------------------------------------