/*
Banking Loan & Credit Risk Analytics
SQL Server analysis script
Dataset: synthetic portfolio for Power BI portfolio use

Expected tables:
Customers(Customer_ID, Age, Gender, Income, Employment_Status, Credit_Score, City, State, Customer_Segment)
Loans(Loan_ID, Customer_ID, Branch_ID, Loan_Type, Loan_Amount, Interest_Rate, Loan_Term_Months,
      Application_Date, Approval_Date, Loan_Status, Default_Status)
Payments(Payment_ID, Loan_ID, Payment_Date, Payment_Amount, Days_Late, Payment_Status)
Branches(Branch_ID, Branch_Name, City, State, Region)
*/

-- =========================================================
-- 1. Portfolio overview
-- =========================================================
SELECT
    COUNT(*) AS Total_Loan_Applications,
    SUM(CASE WHEN Loan_Status = 'Approved' THEN 1 ELSE 0 END) AS Approved_Loans,
    SUM(CASE WHEN Loan_Status = 'Rejected' THEN 1 ELSE 0 END) AS Rejected_Loans,
    SUM(Loan_Amount) AS Total_Approved_Loan_Amount,
    AVG(CASE WHEN Loan_Status = 'Approved' THEN CAST(Loan_Amount AS DECIMAL(18,2)) END) AS Avg_Approved_Loan_Amount
FROM Loans;

-- =========================================================
-- 2. Approval rate
-- =========================================================
SELECT
    CAST(
        100.0 * SUM(CASE WHEN Loan_Status = 'Approved' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS Approval_Rate_Percent
FROM Loans;

-- =========================================================
-- 3. Default rate among approved loans
-- =========================================================
SELECT
    CAST(
        100.0 * SUM(CASE WHEN Default_Status = 'Default' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN Loan_Status = 'Approved' THEN 1 ELSE 0 END), 0)
        AS DECIMAL(10,2)
    ) AS Default_Rate_Percent
FROM Loans;

-- =========================================================
-- 4. Loan portfolio by product
-- =========================================================
SELECT
    Loan_Type,
    COUNT(*) AS Applications,
    SUM(CASE WHEN Loan_Status = 'Approved' THEN 1 ELSE 0 END) AS Approved_Loans,
    SUM(Loan_Amount) AS Approved_Loan_Amount,
    AVG(CASE WHEN Loan_Status = 'Approved' THEN Loan_Amount END) AS Avg_Loan_Amount,
    CAST(
        100.0 * SUM(CASE WHEN Default_Status = 'Default' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN Loan_Status = 'Approved' THEN 1 ELSE 0 END), 0)
        AS DECIMAL(10,2)
    ) AS Default_Rate_Percent
FROM Loans
GROUP BY Loan_Type
ORDER BY Approved_Loan_Amount DESC;

-- =========================================================
-- 5. Credit-risk segmentation
-- =========================================================
SELECT
    c.Customer_Segment,
    COUNT(DISTINCT c.Customer_ID) AS Customers,
    COUNT(l.Loan_ID) AS Loan_Applications,
    SUM(CASE WHEN l.Loan_Status = 'Approved' THEN 1 ELSE 0 END) AS Approved_Loans,
    SUM(CASE WHEN l.Default_Status = 'Default' THEN 1 ELSE 0 END) AS Defaults,
    SUM(l.Loan_Amount) AS Loan_Amount
FROM Customers c
LEFT JOIN Loans l
    ON c.Customer_ID = l.Customer_ID
GROUP BY c.Customer_Segment
ORDER BY Defaults DESC;

-- =========================================================
-- 6. Default rate by credit-score band
-- =========================================================
SELECT
    CASE
        WHEN c.Credit_Score >= 750 THEN '750+'
        WHEN c.Credit_Score >= 700 THEN '700-749'
        WHEN c.Credit_Score >= 650 THEN '650-699'
        WHEN c.Credit_Score >= 600 THEN '600-649'
        ELSE '<600'
    END AS Credit_Score_Band,
    COUNT(l.Loan_ID) AS Loans,
    SUM(CASE WHEN l.Default_Status = 'Default' THEN 1 ELSE 0 END) AS Defaults,
    CAST(
        100.0 * SUM(CASE WHEN l.Default_Status = 'Default' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(l.Loan_ID), 0)
        AS DECIMAL(10,2)
    ) AS Default_Rate_Percent
FROM Customers c
JOIN Loans l
    ON c.Customer_ID = l.Customer_ID
WHERE l.Loan_Status = 'Approved'
GROUP BY
    CASE
        WHEN c.Credit_Score >= 750 THEN '750+'
        WHEN c.Credit_Score >= 700 THEN '700-749'
        WHEN c.Credit_Score >= 650 THEN '650-699'
        WHEN c.Credit_Score >= 600 THEN '600-649'
        ELSE '<600'
    END
ORDER BY Default_Rate_Percent DESC;

-- =========================================================
-- 7. Branch performance
-- =========================================================
SELECT
    b.Branch_ID,
    b.Branch_Name,
    b.City,
    b.State,
    b.Region,
    COUNT(l.Loan_ID) AS Applications,
    SUM(CASE WHEN l.Loan_Status = 'Approved' THEN 1 ELSE 0 END) AS Approved_Loans,
    SUM(l.Loan_Amount) AS Loan_Amount,
    SUM(CASE WHEN l.Default_Status = 'Default' THEN 1 ELSE 0 END) AS Defaults,
    CAST(
        100.0 * SUM(CASE WHEN l.Default_Status = 'Default' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN l.Loan_Status = 'Approved' THEN 1 ELSE 0 END), 0)
        AS DECIMAL(10,2)
    ) AS Default_Rate_Percent
FROM Branches b
LEFT JOIN Loans l
    ON b.Branch_ID = l.Branch_ID
GROUP BY b.Branch_ID, b.Branch_Name, b.City, b.State, b.Region
ORDER BY Loan_Amount DESC;

-- =========================================================
-- 8. Monthly loan trend
-- =========================================================
SELECT
    YEAR(Application_Date) AS Application_Year,
    MONTH(Application_Date) AS Application_Month,
    COUNT(*) AS Applications,
    SUM(CASE WHEN Loan_Status = 'Approved' THEN 1 ELSE 0 END) AS Approved_Loans,
    SUM(Loan_Amount) AS Loan_Amount
FROM Loans
GROUP BY YEAR(Application_Date), MONTH(Application_Date)
ORDER BY Application_Year, Application_Month;

-- =========================================================
-- 9. Payment performance
-- =========================================================
SELECT
    Payment_Status,
    COUNT(*) AS Payments,
    SUM(Payment_Amount) AS Total_Payment_Amount,
    AVG(Days_Late) AS Avg_Days_Late
FROM Payments
GROUP BY Payment_Status
ORDER BY Payments DESC;

-- =========================================================
-- 10. Customers with repeated late payments
-- =========================================================
SELECT TOP 25
    c.Customer_ID,
    c.Age,
    c.Income,
    c.Credit_Score,
    COUNT(p.Payment_ID) AS Total_Payments,
    SUM(CASE WHEN p.Days_Late > 0 THEN 1 ELSE 0 END) AS Late_Payments,
    SUM(CASE WHEN p.Days_Late >= 15 THEN 1 ELSE 0 END) AS Severely_Late_Payments
FROM Customers c
JOIN Loans l
    ON c.Customer_ID = l.Customer_ID
JOIN Payments p
    ON l.Loan_ID = p.Loan_ID
GROUP BY c.Customer_ID, c.Age, c.Income, c.Credit_Score
HAVING SUM(CASE WHEN p.Days_Late > 0 THEN 1 ELSE 0 END) >= 3
ORDER BY Severely_Late_Payments DESC, Late_Payments DESC;

-- =========================================================
-- 11. High-risk loan portfolio
-- =========================================================
SELECT
    l.Loan_ID,
    l.Customer_ID,
    l.Loan_Type,
    l.Loan_Amount,
    l.Interest_Rate,
    c.Credit_Score,
    c.Income,
    c.Customer_Segment,
    l.Default_Status
FROM Loans l
JOIN Customers c
    ON l.Customer_ID = c.Customer_ID
WHERE l.Loan_Status = 'Approved'
  AND (
       c.Credit_Score < 600
       OR l.Default_Status = 'Default'
       OR l.Interest_Rate >= 15
  )
ORDER BY l.Loan_Amount DESC;

-- =========================================================
-- 12. Data-quality checks
-- =========================================================
SELECT 'Customers with missing Customer_ID' AS Check_Name,
       COUNT(*) AS Issue_Count
FROM Customers
WHERE Customer_ID IS NULL

UNION ALL

SELECT 'Loans with missing Customer_ID',
       COUNT(*)
FROM Loans
WHERE Customer_ID IS NULL

UNION ALL

SELECT 'Loans with negative Loan_Amount',
       COUNT(*)
FROM Loans
WHERE Loan_Amount < 0

UNION ALL

SELECT 'Payments with negative Payment_Amount',
       COUNT(*)
FROM Payments
WHERE Payment_Amount < 0;
