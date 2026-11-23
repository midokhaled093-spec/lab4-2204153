-- Lab 4 - Problem 1: COMPANY database (extended)
-- Run: mysql -u root -p < problem1_DDL.sql
DROP DATABASE IF EXISTS company;
CREATE DATABASE company;
USE company;

-- DEPARTMENT is created first; its mgr_ssn foreign key is added after EMPLOYEE exists
-- (EMPLOYEE.Dno refers to DEPARTMENT and DEPARTMENT.mgr_ssn refers to EMPLOYEE).
CREATE TABLE department (
    Dnumber        INT          NOT NULL,
    Dname          VARCHAR(50)  NOT NULL,
    mgr_ssn        CHAR(9)      NULL,
    mgr_start_date DATE         NULL,
    PRIMARY KEY (Dnumber),
    UNIQUE (Dname)
);

CREATE TABLE employee (
    ssn       CHAR(9)       NOT NULL,
    fname     VARCHAR(30)   NOT NULL,
    lname     VARCHAR(30)   NOT NULL,
    bdate     DATE          NULL,
    address   VARCHAR(100)  NULL,
    gender    CHAR(1)       NULL,
    salary    DECIMAL(10,2) NULL,
    super_ssn CHAR(9)       NULL,
    Dno       INT           NOT NULL,
    PRIMARY KEY (ssn),
    FOREIGN KEY (super_ssn) REFERENCES employee (ssn),
    FOREIGN KEY (Dno)       REFERENCES department (Dnumber)
);

ALTER TABLE department
    ADD FOREIGN KEY (mgr_ssn) REFERENCES employee (ssn);

CREATE TABLE project (
    Pnumber   INT          NOT NULL,
    Pname     VARCHAR(50)  NOT NULL,
    Plocation VARCHAR(50)  NULL,
    Dno       INT          NOT NULL,
    PRIMARY KEY (Pnumber),
    FOREIGN KEY (Dno) REFERENCES department (Dnumber)
);

CREATE TABLE works_on (
    essn  CHAR(9)      NOT NULL,
    Pno   INT          NOT NULL,
    hours DECIMAL(4,1) NULL,
    PRIMARY KEY (essn, Pno),
    FOREIGN KEY (essn) REFERENCES employee (ssn),
    FOREIGN KEY (Pno)  REFERENCES project (Pnumber)
);

CREATE TABLE dependent (
    essn           CHAR(9)      NOT NULL,
    dependent_name VARCHAR(50)  NOT NULL,
    gender         CHAR(1)      NULL,
    bdate          DATE         NULL,
    relationship   VARCHAR(20)  NULL,
    PRIMARY KEY (essn, dependent_name),
    FOREIGN KEY (essn) REFERENCES employee (ssn)
);
