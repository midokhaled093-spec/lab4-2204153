-- Lab 4 - Problem 1: rows for the five tables
USE company;

-- 4 departments; managers are set after the employees exist.
-- Department 4 (Marketing) has no employees.
INSERT INTO department (Dnumber, Dname, mgr_ssn, mgr_start_date) VALUES
(1, 'Engineering',    NULL, NULL),
(2, 'Research',       NULL, NULL),
(3, 'Administration', NULL, NULL),
(4, 'Marketing',      NULL, NULL);

-- 9 employees. Ahmed Hassan and Mona Ibrahim have no supervisor.
-- Department 1 has 4 employees, department 2 has 3, department 3 has 2.
INSERT INTO employee (ssn, fname, lname, bdate, address, gender, salary, super_ssn, Dno) VALUES
('111111111', 'Ahmed',   'Hassan',  '1980-04-12', 'Smouha, Alexandria',      'M', 5500.00, NULL,        1),
('222222222', 'Sara',    'Mostafa', '1987-09-03', 'Nasr City, Cairo',        'F', 4200.00, '111111111', 1),
('333333333', 'Omar',    'Fathy',   '1990-01-25', 'Sidi Gaber, Alexandria',  'M', 3500.00, '111111111', 1),
('444444444', 'Nour',    'Adel',    '1985-06-18', 'Miami, Alexandria',       'F', 4800.00, '222222222', 2),
('555555555', 'Youssef', 'Samir',   '1992-11-30', 'Dokki, Giza',             'M', 2800.00, '222222222', 2),
('666666666', 'Mona',    'Ibrahim', '1978-02-09', 'Stanley, Alexandria',     'F', 7200.00, NULL,        3),
('777777777', 'Karim',   'Tarek',   '1993-07-14', 'Maadi, Cairo',            'M', 3100.00, '666666666', 3),
('888888888', 'Laila',   'Essam',   '1991-12-05', 'Gleem, Alexandria',       'F', 3900.00, '111111111', 1),
('999999999', 'Hany',    'Salah',   '1995-03-22', 'Montaza, Alexandria',     'M', 2500.00, '444444444', 2);

UPDATE department SET mgr_ssn = '111111111', mgr_start_date = '2015-01-01' WHERE Dnumber = 1;
UPDATE department SET mgr_ssn = '444444444', mgr_start_date = '2018-09-01' WHERE Dnumber = 2;
UPDATE department SET mgr_ssn = '666666666', mgr_start_date = '2012-03-15' WHERE Dnumber = 3;

-- 5 projects. Project 50 has nobody working on it.
INSERT INTO project (Pnumber, Pname, Plocation, Dno) VALUES
(10, 'Smart Campus',     'Alexandria', 1),
(20, 'Network Upgrade',  'Cairo',      1),
(30, 'Lab Research',     'Alexandria', 2),
(40, 'Payroll System',   'Giza',       3),
(50, 'Marketing Study',  'Cairo',      4);

-- 9 works_on rows. Ahmed (111111111) and Omar (333333333) work on two projects.
INSERT INTO works_on (essn, Pno, hours) VALUES
('111111111', 10, 20.0),
('111111111', 20, 10.0),
('222222222', 10, 15.0),
('333333333', 10, 12.0),
('333333333', 20,  8.0),
('444444444', 30, 25.0),
('555555555', 30, 10.0),
('666666666', 40, 18.0),
('777777777', 40,  6.0);

-- 4 dependents
INSERT INTO dependent (essn, dependent_name, gender, bdate, relationship) VALUES
('111111111', 'Salma Hassan',  'F', '2015-03-12', 'Daughter'),
('111111111', 'Adam Hassan',   'M', '2018-07-21', 'Son'),
('222222222', 'Tamer Mostafa', 'M', '1990-01-30', 'Spouse'),
('666666666', 'Yara Ibrahim',  'F', '2012-09-05', 'Daughter');
