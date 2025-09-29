CREATE DATABASE mybankdb;
use mybankdb;


SELECT * FROM Customers;
SELECT * FROM Accounts;
SELECT * FROM Transactions;
SELECT * FROM Loans;
SELECT * FROM  CreditCards;
SELECT * FROM  Branches;
SELECT * FROM ATMs;

-- Aggregate queries(sum,max,min,count,avg)
-- claculate total number of customers
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- calculate total number of accounts
SELECT COUNT(*) AS TotalAccounts FROM Accounts;

-- calculate total loan amount
SELECT SUM(Amount) AS TotalLoansAmount FROM Loans;

-- calculate total credits limit accross all credit cards
SELECT SUM(CreditLimit) AS TotalCreditLimit FROM creditcards;

-- find all active accounts
SELECT * FROM Accounts WHERE Status='Active';

-- find all accounts made on 15th jan 2023
SELECT * FROM Transactions WHERE TransactionDate > '2023-01-15';

-- find loans with interest rates above 5.0
SELECT * FROM Loans WHERE InterestRate > 5.0;

-- Find credit with balances exceeding the credit limit
SELECT * FROM CreditCards WHERE Balance > Creditlimit;

-- Retrieve customer details along with their accounts
SELECT c.CustomerID,c.Name,c.Age,a.AccountNumber,a.AccountType,a.Balance
FROM Customers c 
JOIN Accounts a ON c.CustomerID=a.CustomerID;

-- Retrieve transactions details along with associated account and customer information
SELECT t.TransactionID,t.TransactionDate,t.Amount,t.Type,T.Description,a.AccountNumber,a.AccountType,c.Name AS CustomerName
FROM Transactions t
JOIN Accounts a ON t.AccountNumber=a.AccountNumber
JOIN Customers c ON a.CustomerID=c.CustomerID;

-- top 10 customer with highest loan amount
SELECT c.Name,l.Amount AS LoanAmount
FROM Customers c 
JOIN Loans l ON c.CustomerID=l.CustomerID
ORDER BY l.Amount DESC
LIMIT 10;

-- delete inactive accounts
SET SQL_SAFE_UPDATES=0;
DELETE FROM Accounts
WHERE Status='Inactive';

-- JOINS QUERIES
-- find customer with multiple accounts
SELECT c.CustomerID,c.Name,COUNT(a.AccountNumber) AS NumAccounts
FROM Customers c
JOIN Accounts a ON c.CustomerID=a.CustomerID
GROUP BY c.CustomerID,c.Name
HAVING COUNT(a.AccountNumber)>1;

-- print the first 3 character of name from customers table
SELECT SUBSTRING(Name,1,3) AS FirstThreeCharactersOfName -- substring will print  column k andr ke name ke pehle 3 character (column name, start,end)
FROM Customers;

-- print the name from customers table into two columns firstname and lastname
SELECT 
      SUBSTRING_INDEX(Name,' ',1) AS FirstName,
      SUBSTRING_INDEX(Name,' ',-1) AS LastName
FROM Customers;

-- SQL query to show only odd rows from customers table
SELECT * FROM Customers
WHERE MOD(CustomerID,2)<>0;

-- sql query to determine the 5th highets loan amount without using limit keyword
SELECT DISTINCT Amount
FROM Loans L1
WHERE 5=(
         SELECT COUNT(DISTINCT Amount)
         FROM Loans L2
         WHERE L2.Amount>=L1.Amount
         );
         
-- SQL query to show the second highest loan from the loans table using sub-query
SELECT MAX(Amount) AS Secondhighestloan
FROM Loans
WHERE Amount<(
             SELECT MAX(Amount) 
             FROM Loans
);

-- sql query to list customerID whose account is INACTIVE
SELECT CustomerID
FROM Accounts
WHERE Status ='Inactive';

-- sql query to fetch the first  row of the customers table
SELECT * FROM Customers
LIMIT 1;

-- SQL query to show the current date and time
SELECT NOW() AS CurrentDateTime;

-- sql query to create a new table which consits of data and structure copied from the the customers
CREATE TABLE CustomersClone LIKE Customers;
INSERT INTO CustomersClone SELECt * FROM Customers;
 
 -- sql query toc calculate how many days are remaining for customers to pay off the loans
 SELECT 
        CustomerID,
        DATEDIFF(ENDDATE,CURDATE()) AS DaysRemaining
FROM Loans
WHERE ENDDATE>CURDATE();

-- Query to find the latest transaction date for each account
SELECT AccountNumber,MAX(Transactiondate) AS LatestTransactionDate
FROM Transactions
GROUP BY AccountNumber;

-- find the average age of customers
SELECT AVG(Age) AS AverageAge
FROM Customers;

-- find accounts with less than minimum amount for accounts opened before 1st jan 2022
SELECT AccountNumber,Balance
FROM Accounts
WHERE Balance<25000
AND OpenDate<='2022-01-01';

-- find loans that are currently active
SELECT * FROM Loans
WHERE ENDDATE>=CURDATE()
AND Status='Active';

-- find the total amount of transaction for each account for a specific month
SELECT AccountNumber,SUM(Amount) AS TotalAmount
FROM Transactions
WHERE MONTH(TransactionDate)=6
AND YEAR(TransactionDate)=2023
GROUP BY AccountNumber;

-- find the average credit card balance for each customer
SELECT CustomerID,AVG(Balance) AS AverageCreditCardBalance
FROM CreditCards
GROUP BY CustomerID;

-- find no. of inactive atms per location
SELECT Location,COUNT(*) AS NumberOFActiveATMs
FROM ATMs
WHERE Status='Oout Of Service'
GROUP BY Location;

--  categorize customers into three age groups
--  categories customer into three age groups
SELECT 
    name,
    age,
    CASE
      WHEN age < 30 THEN 'Below 30'
      WHEN age BETWEEN 30 AND 60 THEN '30 TO 60'
      ELSE 'ABOVE 60'
	END AS age_group
FROM customers;