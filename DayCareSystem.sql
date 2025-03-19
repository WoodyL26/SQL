create database DayCareSystem;

use DayCareSystem;

CREATE TABLE HealthyEatingProgram 
(
Program_ID VARCHAR(512) PRIMARY KEY,
Name VARCHAR(512),
[Type of food/drink] VARCHAR(512),
Amount_of_calorie INT
);

INSERT INTO HealthyEatingProgram VALUES
('P01', 'Low-Carbohydrate Diet', 'Avocado Waldorf Chicken Salad', '243'),
('P02', 'Dietary Fibre Diet', 'Lean on Legumes', '115'),
('P03', 'High Protein Diet', 'Roasted Spiced Salmon', '744'),
('P04', 'Dairy-Free Diet', 'Macaroni and Cheese', '203'),
('P05', 'Whole-Grain Diet', 'Barley with Kale Pesto', '502'),
('P06', 'Fruitarian Diet', 'Strawberry Corn Salsa', '145');

CREATE TABLE Staff 
(
Staff_ID VARCHAR(512) PRIMARY KEY,
Name VARCHAR(512),
Age INT,
Gender VARCHAR(512),
Address VARCHAR(512),
Years_of_Experience INT,
Qualification_Level VARCHAR(512),
Salary INT,
);

INSERT INTO Staff VALUES
('S01', 'Eva', '20', 'Female', 'Kajang', '3', 'Certificate', '1500'),
('S02', 'Noah', '30', 'Male', 'Kuala Lumpur', '7', 'Diploma', '2000'),
('S03', 'Liam', '25', 'Male', 'Kuala Lumpur', '6', 'Certificate', '1500'),
('S04', 'Kelly', '34', 'Female', 'Bukit Jalil', '10', 'Degree', '2400'),
('S05', 'Olivia', '50', 'Female', 'Ipoh', '15', 'Master', '3500');

CREATE TABLE [Group]
(
Group_ID VARCHAR(512) PRIMARY KEY,
[Session(Morning/Evening)] VARCHAR(512),
Start_Time TIME,
End_Time TIME,
Program_ID VARCHAR(512) FOREIGN KEY REFERENCES HealthyEatingProgram(Program_ID),
Staff_ID VARCHAR(512) FOREIGN KEY REFERENCES Staff(Staff_ID)
);

INSERT INTO [Group] VALUES
('G01', 'Morning', '10:45:00', '11:45:00', 'P01', 'S05'),
('G02', 'Evening', '19:00:00', '20:00:00', 'P04', 'S03'),
('G03', 'Morning', '7:45:00', '8:45:00', 'P05', 'S02'),
('G04', 'Evening', '19:00:00', '20:00:00', 'P03', 'S04'),
('G05', 'Morning','09:45:00', '10:45:00', 'P01', 'S01');

CREATE TABLE Children
(
Children_ID VARCHAR(512) PRIMARY KEY,
Name VARCHAR(512),
Gender VARCHAR(512),
Birth_Day DATE,
Weight INT,
Height INT,
Group_ID VARCHAR(512) FOREIGN KEY REFERENCES [Group](Group_ID) 
);

INSERT INTO Children VALUES
('C01', 'Sophia', 'Female', '2018-01-01', '20', '120', 'G05'),
('C02', 'Jackson', 'Male', '1999-02-14', '40', '110', 'G03'),
('C03', 'Mia', 'Female', '2001-03-17', '30', '140', 'G02'),
('C04', 'Biden', 'Male', '2002-04-22', '65', '100', 'G01'),
('C05', 'Omar', 'Male', '2018-01-25', '45', '125', 'G04');

CREATE TABLE Guardian
(
Guardian_ID VARCHAR(512) PRIMARY KEY,
Name VARCHAR(512),
Age INT,
Address VARCHAR(512),
Contact_Number VARCHAR(512),
Relationship VARCHAR(512),
);

INSERT INTO Guardian VALUES
('G01', 'Alis', '25', 'Puncak Jalil', '012-3456789', 'Father'),
('G02', 'Lucy', '30', 'Puncak Jalil', '011-23456789', 'Mother'),
('G03', 'Anna', '40', 'Ipoh', '014-567 8901', 'Aunt'),
('G04', 'Dickson', '80', 'Ipoh', '016-789 0123', 'Grandfather'),
('G05', 'Biden', '75', 'Selangor', '019-012 3456', 'Grandfather'),
('G06', 'Mikey', '60', 'Kuala Lumppur', '013-456 7890', 'Father'),
('G07', 'Mira', '55', 'Selangor', '015-678 9012', 'Mother'),
('G08', 'Tong', '47', 'Puncak Jalil','018-901 2345', 'Father'),
('G09', 'John', '65', 'Bukit Jalil','017-234 5678', 'Father'),
('G10', 'Elsa', '35', 'Puncak Jalil', '010-345 6789', 'Mother');

CREATE TABLE ChildrenGuardian
(
ChildrenGurdian_ID VARCHAR(512) PRIMARY KEY,
Children_ID VARCHAR(512) FOREIGN KEY REFERENCES Children(Children_ID),
Guardian_ID VARCHAR(512) FOREIGN KEY REFERENCES Guardian(Guardian_ID),
);

INSERT INTO ChildrenGuardian VALUES
('CG1', 'C01', 'G01'),
('CG2', 'C01', 'G02'),
('CG3', 'C02', 'G03'),
('CG4', 'C02', 'G04'),
('CG5', 'C03', 'G05'),
('CG6', 'C03', 'G06'),
('CG7', 'C04', 'G07'),
('CG8', 'C04', 'G08'),
('CG9', 'C05', 'G09'),
('CG10', 'C05', 'G10');

--Q1
UPDATE Children
SET Weight='17', Height='120'
where Children_ID='C03';

--Q2
SELECT * FROM Children
WHERE Group_ID IN 
(SELECT Group_ID FROM [Group] 
WHERE [Session(Morning/Evening)] = 'Morning');

--Q3
SELECT * FROM Guardian
WHERE Address = 'Puncak Jalil'
ORDER BY Name, Address;

--Q4
SELECT AVG(Weight) AS [AVG WEIGHT OF CHILDREN]
FROM Children;
SELECT AVG(Height) AS [AVG HEIGHT OF CHILDREN]
FROM Children;

--Q5
SELECT COUNT(Children_ID) 
AS [Total no of children in afternoon session]
FROM Children
WHERE Group_ID IN 
(SELECT Group_ID FROM [Group] 
WHERE [Session(Morning/Evening)] = 'Afternoon');

--Q6
SELECT * FROM Staff
WHERE Years_of_Experience BETWEEN 1 AND 3
ORDER BY Name ASC;

--Q7
SELECT * FROM Staff
WHERE 
(Qualification_Level = 'Diploma' 
OR Qualification_Level = 'Degree') 
AND Salary < 4000;

--Q8
SELECT * FROM Guardian
WHERE Name LIKE '%s' 
AND Relationship = 'Father';
/*Based on the information, it seems 
that there is no Last_Name column in the Guardian table.
*/

--Q9
SELECT * FROM Children
WHERE Birth_Day = '2018-01-01'
ORDER BY Name DESC;

--Q10
SELECT * FROM Children
WHERE Group_ID IN 
(SELECT Group_ID FROM [Group] 
WHERE Staff_ID = 'S04');

--Q11
SELECT Children.Children_ID, Children.Name
FROM Children
JOIN [Group] ON Children.Group_ID = [Group].Group_ID
JOIN HealthyEatingProgram 
ON [Group].Program_ID = HealthyEatingProgram.Program_ID
WHERE HealthyEatingProgram.Amount_of_calorie < 1000;

--Q12
SELECT Children.Children_ID, Children.Name
FROM Children
WHERE Children.Gender = 'Male' 
AND DATEDIFF(year, Children.Birth_Day, GETDATE()) > 10;

--New Question: The children which belong to the group that the program name is 'High Protein Diet'
SELECT Children.Children_ID
FROM Children
WHERE Group_ID IN (SELECT Group_ID FROM [Group]
WHERE Program_ID IN (SELECT Program_ID FROM HealthyEatingProgram 
WHERE Name = 'High Protein Diet'));