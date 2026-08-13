# DAX Measures – Banking Loan Risk Analysis

This document contains the key DAX measures created for the Power BI Banking Loan Portfolio and Customer Risk Analysis dashboard.

## 1. Total Customers

```DAX
Total Customers =
DISTINCTCOUNT(customers[Customer_ID])

Calculates the total number of unique customers in the banking dataset.

2. Total Loans
Total Loans =
COUNT(loans[Loan_ID])

Calculates the total number of loans in the portfolio.

3. Total Loan Amount
Total Loan Amount =
SUM(loans[Loan_Amount])

Calculates the total value of all loans issued.

4. Total Payments
Total Payments =
SUM(loans[Total_Payment])

Calculates the total payments associated with the loan portfolio.

5. Average Loan Amount
Average Loan Amount =
AVERAGE(loans[Loan_Amount])

Calculates the average loan amount across all loans.

6. Average Interest Rate
Average Interest Rate =
AVERAGE(loans[Interest_Rate])

Calculates the average interest rate across the loan portfolio.

7. Loan Count
Loan Count =
COUNT(loans[Loan_ID])

Counts the number of loans based on the selected filters.

These DAX measures allow the Power BI dashboard to dynamically analyze:
Customer volume
Loan portfolio size
Total loan exposure
Payment performance
Average loan value
Interest rate trends
Customer risk segments
Loan status and default patterns
The measures respond dynamically to Power BI slicers and visual-level filters.