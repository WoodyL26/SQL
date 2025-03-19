CREATE DATABASE APUCafeFoodOrderingSystem;

USE APUCafeFoodOrderingSystem;

CREATE TABLE Members
(
    MemberID NVARCHAR(40) PRIMARY KEY,
    Name NVARCHAR(40),
    Role NVARCHAR(40),
    Gender NVARCHAR(40),
    ContactNumber NVARCHAR(15)
);

INSERT INTO Members VALUES
    ('M01', 'John Doe', 'Student', 'Male', '0174445555'),
    ('M02', 'Jane Smith', 'Staff', 'Female', '0112222333'),
    ('M03', 'Alice Johnson', 'Student', 'Female', '0132224444'),
    ('M04', 'Bob Brown', 'Staff', 'Male', '0175556666'),
    ('M05', 'Charlie Davis', 'Student', 'Male', '0198887777'),
    ('M06', 'Davis Lee', 'Manager', 'Male', '0123456789');

CREATE TABLE Food
(
    FoodID NVARCHAR(40) PRIMARY KEY,
    Name NVARCHAR(40),
    Price DECIMAL(10, 2)
);

INSERT INTO Food VALUES
    ('F01', 'Chicken Rice', 5.00),
    ('F02', 'Vegetarian Pizza', 7.50),
    ('F03', 'Beef Burger', 6.00),
    ('F04', 'Caesar Salad', 4.50),
    ('F05', 'Spaghetti Bolognese', 8.00);

CREATE TABLE Orders
(
    OrderID NVARCHAR(40) PRIMARY KEY,
    MemberID NVARCHAR(40) FOREIGN KEY REFERENCES Members(MemberID),
    TotalCost DECIMAL(10, 2),
    OrderDate DATE,
    Status NVARCHAR(40)
);

INSERT INTO Orders VALUES
    ('O01', 'M01', 13.50, '2023-07-01', 'Completed'),
    ('O02', 'M02', 15.00, '2023-07-02', 'Pending'),
    ('O03', 'M03', 9.00, '2023-07-03', 'Completed'),
    ('O04', 'M04', 18.00, '2023-07-04', 'Completed'),
    ('O05', 'M05', 12.00, '2023-08-05', 'Pending'),
    ('O06', 'M06', 10.50, '2023-08-05', 'Completed'),
    ('O07', 'M06', 15.00, '2023-08-05', 'Pending'),
    ('O08', 'M05', 18.00, '2023-08-05', 'Completed'),
    ('O09', 'M02', 9.00, '2023-08-05', 'Pending'),
    ('O10', 'M02', 13.50, '2023-08-05', 'Completed'),
    ('O11', 'M03', 13.50, '2023-08-06', 'Completed');


CREATE TABLE OrderDetails
(
    OrderDetailID NVARCHAR(40) PRIMARY KEY,
    OrderID NVARCHAR(40) FOREIGN KEY REFERENCES Orders(OrderID),
    FoodID NVARCHAR(40) FOREIGN KEY REFERENCES Food(FoodID),
    Quantity INT
);

INSERT INTO OrderDetails VALUES
    ('OD01', 'O01', 'F01', 2),
    ('OD02', 'O02', 'F04', 1),
    ('OD03', 'O02', 'F02', 2),
    ('OD04', 'O03', 'F03', 1),
    ('OD05', 'O03', 'F05', 1),
    ('OD06', 'O04', 'F02', 1),
    ('OD07', 'O04', 'F05', 2),
    ('OD08', 'O05', 'F03', 2),
    ('OD09', 'O06', 'F03', 1),
    ('OD10', 'O06', 'F04', 1);

CREATE TABLE Feedback
(
    FeedbackID NVARCHAR(40) PRIMARY KEY,
    FoodID NVARCHAR(40) FOREIGN KEY REFERENCES Food(FoodID),
    MemberID NVARCHAR(40) FOREIGN KEY REFERENCES Members(MemberID),
    Rating INT
);

INSERT INTO Feedback VALUES
    ('FD01', 'F01', 'M01', 5),
    ('FD02', 'F02', 'M02', 4),
    ('FD03', 'F03', 'M03', 3),
    ('FD04', 'F04', 'M04', 5),
    ('FD05', 'F05', 'M05', 4),
    ('FD06', 'F05', 'M06', 1);

CREATE TABLE Chef
(
    ChefID NVARCHAR(40) PRIMARY KEY,
    Name NVARCHAR(40)
);

INSERT INTO Chef VALUES
    ('C01', 'Chef A'),
    ('C02', 'Chef B'),
    ('C03', 'Chef C');

CREATE TABLE CookedMeals
(
    MealID NVARCHAR(40) PRIMARY KEY,
    ChefID NVARCHAR(40) FOREIGN KEY REFERENCES Chef(ChefID),
    OrderDetailID NVARCHAR(40) FOREIGN KEY REFERENCES OrderDetails(OrderDetailID)
);

INSERT INTO CookedMeals VALUES
    ('CM01', 'C01', 'OD01'),
    ('CM02', 'C02', 'OD03'),
    ('CM03', 'C03', 'OD04'),
    ('CM04', 'C01', 'OD05'),
    ('CM05', 'C02', 'OD07'),
    ('CM06', 'C02', 'OD09'),
    ('CM07', 'C03', 'OD10');

--Q1
SELECT F.FoodID, F.Name, FB.Rating
FROM Food F
INNER JOIN Feedback FB ON F.FoodID = FB.FoodID
WHERE FB.Rating = (SELECT MAX(Rating) FROM Feedback);

--Q2
SELECT M.MemberID, M.Name, COUNT(F.FeedbackID) AS TotalFeedback
FROM Members M
JOIN Feedback F ON M.MemberID = F.MemberID
GROUP BY M.MemberID, M.Name;

--Q3
SELECT CH.ChefID, CH.Name, COUNT(*) AS MealsOrderedByManagers
FROM Chef CH
JOIN CookedMeals CM ON CH.ChefID = CM.ChefID
JOIN OrderDetails OD ON CM.OrderDetailID = OD.OrderDetailID
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Members M ON O.MemberID = M.MemberID
WHERE M.Role = 'Manager'
GROUP BY CH.ChefID, CH.Name;

--Q4
SELECT CH.ChefID, CH.Name, COUNT(CM.MealID) AS NumberOfMealsCooked
FROM Chef CH
JOIN CookedMeals CM ON CH.ChefID = CM.ChefID
GROUP BY CH.ChefID, CH.Name;

--Q5
SELECT F.FoodID, F.Name
FROM Food F
JOIN Feedback FB ON F.FoodID = FB.FoodID
GROUP BY F.FoodID, F.Name
HAVING AVG(FB.Rating) > (SELECT AVG(Rating) FROM Feedback);

--Q6
SELECT TOP 3 F.FoodID, F.Name, F.Price, SUM(OD.Quantity) AS QuantitySold
FROM Food F
JOIN OrderDetails OD ON F.FoodID = OD.FoodID
GROUP BY F.FoodID, F.Name, F.Price
ORDER BY QuantitySold DESC;

--Q7
SELECT TOP 3 M.MemberID, M.Name, M.Role, SUM(O.TotalCost) AS TotalSpent
FROM Members M
JOIN Orders O ON M.MemberID = O.MemberID
GROUP BY M.MemberID, M.Name, M.Role
ORDER BY TotalSpent DESC;

--Q8
SELECT MemberID, Name, Role, Gender
FROM Members
WHERE Role = 'Student' OR Role = 'Staff'
ORDER BY Gender;

--Q9
SELECT M.MemberID, M.Role, M.ContactNumber, F.FoodID, F.Name AS FoodName, OD.Quantity, O.OrderDate, O.Status
FROM Orders O
JOIN Members M ON O.MemberID = M.MemberID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Food F ON OD.FoodID = F.FoodID
WHERE O.Status != 'Completed';

--Q10
SELECT M.MemberID, M.Name, M.Role, COUNT(O.OrderID) AS TotalOrders
FROM Members M
JOIN Orders O ON M.MemberID = O.MemberID
WHERE M.Role = 'Student' OR M.Role = 'Staff'
GROUP BY M.MemberID, M.Name, M.Role
HAVING COUNT(O.OrderID) > 2;



