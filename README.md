# Loan Portfolio & Customer Risk Analysis

## 📊 Project Overview

This project analyzes a banking loan portfolio to understand customer risk, loan performance, loan status, regional trends, and key portfolio metrics.

The project combines SQL analysis, DAX measures, and Power BI visualization to transform banking data into actionable business insights.

## 🎯 Business Objective

The main objectives of this project are to:

- Analyze the overall loan portfolio
- Understand customer risk segments
- Monitor loan amounts and loan volumes
- Analyze approved and rejected loans
- Identify default patterns
- Compare loan performance across regions
- Analyze average interest rates by customer risk segment
- Create an interactive executive dashboard

## 🛠️ Tools & Technologies

- SQL
- Power BI
- DAX
- Microsoft Excel
- Data Modeling
- Data Visualization
- Business Analytics

## 📁 Dataset

The project uses banking-related datasets containing information about:

- Customers
- Loans
- Payments
- Branches

Key customer attributes include customer segment, credit score, income, employment status, age, gender, city, state, and other customer information.

Loan-related attributes include loan amount, interest rate, loan status, default status, loan term, application date, approval date, customer ID, and branch ID.

## 📈 Power BI Dashboard

The Power BI dashboard provides an executive-level overview of the loan portfolio.

### Key KPIs

- **Total Customers:** 5K
- **Total Loans:** 8K
- **Total Loan Amount:** 504M
- **Total Payments:** 25.27M
- **Average Loan Amount:** 63.06K

### Dashboard Visualizations

The dashboard includes:

- Loan status distribution
- Loan amount by customer risk segment
- Default status analysis
- Loan amount by region
- Average interest rate by customer segment
- Interactive customer risk segment slicer

## 🧮 DAX

DAX measures were created to calculate key portfolio metrics such as:

- Total Customers
- Total Loans
- Total Loan Amount
- Total Payments
- Average Loan Amount
- Average Interest Rate
- Loan and customer segmentation metrics

These measures allow the dashboard to dynamically respond to user selections and filters.

## 🗄️ SQL Analysis

SQL was used to perform data analysis and answer business questions related to:

- Loan portfolio performance
- Customer risk
- Loan status
- Default status
- Regional performance
- Customer and loan relationships

## 🔍 Key Business Questions

The analysis focuses on questions such as:

1. How large is the current loan portfolio?
2. Which customer risk segments have the highest loan amounts?
3. What is the distribution of approved and rejected loans?
4. Which regions contribute the most to the loan portfolio?
5. How does the average interest rate vary across customer risk segments?
6. What proportion of loans are associated with default status?
7. Which customer segments should receive greater risk attention?

## 💡 Business Value

This dashboard can help banking teams:

- Monitor portfolio performance
- Identify higher-risk customer segments
- Understand regional loan trends
- Track loan and default patterns
- Support credit-risk decision making
- Improve portfolio monitoring and reporting

## 📂 Project Structure

```text
Loan-Portfolio-Customer-Risk-Analysis/
│
├── PowerBi/
│   └── Loan_Portfolio_Customer_Analysis.pbix
│
├── SQL/
│   └── Banking_Risk_Analysis.sql
│
└── README.md