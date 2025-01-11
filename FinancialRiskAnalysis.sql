select
date_format(ApplicationDate, '%Y') as _Year,
case
	when LoanApproved = 1 then 'Approved'
    else 'Declined'
end as approval_status,
count(*) as total_applicants,
round(avg(Age),2) as avg_age,
round(avg(AnnualIncome),2) as avg_income,
round(avg(TotalAssets),2) as avg_assets,
round(avg(TotalLiabilities),2) as avg_liabilities,
round(avg(SavingsAccountBalance),2) as avg_savings,
round(avg(JobTenure),2) as avg_jobtenure,
round(avg(TotalDebtToIncomeRatio),2) as avg_debtincomeratio
from loan
group by _Year, LoanApproved;


-- 1. Identifying the Number of Applicants with High Debt-to-Income Ratios and Loan Defaults (Yearly)
SELECT 
    YEAR(ApplicationDate) AS Year,
    COUNT(*) AS HighRiskApplicants
FROM 
    Loan
WHERE 
    DebtToIncomeRatio > 0.40 
    AND PreviousLoanDefaults > 0
GROUP BY 
    YEAR(ApplicationDate)
ORDER BY 
    Year;


-- 2. Aggregating Loan Default Probability Based on Credit Score and Bankruptcy History (Yearly)
SELECT 
    YEAR(ApplicationDate) AS Year,
    CASE 
        WHEN CreditScore BETWEEN 300 AND 400 THEN '300-400'
        WHEN CreditScore BETWEEN 401 AND 600 THEN '401-600'
        WHEN CreditScore BETWEEN 601 AND 750 THEN '601-750'
        WHEN CreditScore BETWEEN 751 AND 850 THEN '751-850'
    END AS CreditScoreRange,
    BankruptcyHistory,
    COUNT(*) AS TotalApplicants,
    SUM(CASE WHEN LoanApproved = 0 THEN 1 ELSE 0 END) AS LoanDefaults
FROM 
    Loan
GROUP BY 
    YEAR(ApplicationDate), CreditScoreRange, BankruptcyHistory
ORDER BY 
    Year, CreditScoreRange;



-- 3. Aggregating the Loan Amount and Monthly Debt Payments for High-Risk Applicants (Yearly)
SELECT 
    YEAR(ApplicationDate) AS Year,
    AVG(LoanAmount) AS AvgLoanAmount,
    AVG(MonthlyDebtPayments) AS AvgMonthlyDebtPayments,
    COUNT(*) AS HighRiskApplicants
FROM 
    Loan
WHERE 
    DebtToIncomeRatio > 0.40 
    OR CreditScore < 600
GROUP BY 
    YEAR(ApplicationDate)
ORDER BY 
    Year;


-- 4. Identifying Applicants with Long Loan Durations and Low Monthly Income (Yearly)
SELECT 
    YEAR(ApplicationDate) AS Year,
    COUNT(*) AS HighRiskApplicants
FROM 
    Loan
WHERE 
    LoanDuration > 60 
    AND MonthlyIncome < 3000
GROUP BY 
    YEAR(ApplicationDate)
ORDER BY 
    Year;


-- 5. Aggregating Loan Approval Rates Based on Employment Status (Yearly)
SELECT 
    YEAR(ApplicationDate) AS Year,
    EmploymentStatus,
    AVG(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) AS LoanApprovalRate,
    COUNT(*) AS TotalApplicants
FROM 
    Loan
GROUP BY 
    YEAR(ApplicationDate), EmploymentStatus
ORDER BY 
    Year, EmploymentStatus;


-- 6. Identifying the Average Credit Utilization and Loan Approval by Open Credit Lines (Yearly)
SELECT 
    YEAR(ApplicationDate) AS Year,
    NumberOfOpenCreditLines,
    AVG(CreditCardUtilizationRate) AS AvgCreditCardUtilization,
    AVG(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) AS LoanApprovalRate
FROM 
    Loan
GROUP BY 
    YEAR(ApplicationDate), NumberOfOpenCreditLines
ORDER BY 
    Year, NumberOfOpenCreditLines;


-- 7. Aggregating Number of Applicants with High Bankruptcy History and Large Loan Amounts (Yearly)
SELECT 
    YEAR(ApplicationDate) AS Year,
    COUNT(*) AS HighRiskApplicants
FROM 
    Loan
WHERE 
    BankruptcyHistory > 0 
    AND LoanAmount > 70000
GROUP BY 
    YEAR(ApplicationDate)
ORDER BY 
    Year;


-- 8. Aggregating Total Liabilities and Loan Approval Rates (Yearly)
SELECT 
    YEAR(ApplicationDate) AS Year,
    CASE 
        WHEN TotalLiabilities < 50000 THEN 'Low Liability'
        WHEN TotalLiabilities BETWEEN 50000 AND 100000 THEN 'Medium Liability'
        ELSE 'High Liability'
    END AS LiabilityGroup,
    COUNT(*) AS TotalApplicants,
    AVG(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) AS LoanApprovalRate
FROM 
    Loan
GROUP BY 
    YEAR(ApplicationDate), LiabilityGroup
ORDER BY 
    Year;


-- 9. Aggregating Loan Approval Rates Based on Age and Education Level (Yearly)
SELECT 
    YEAR(ApplicationDate) AS Year,
    CASE 
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        WHEN Age BETWEEN 51 AND 60 THEN '51-60'
        ELSE '60+' 
    END AS AgeGroup,
    COUNT(*) AS TotalApplicants,
    AVG(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) AS LoanApprovalRate
FROM 
    Loan
GROUP BY 
    YEAR(ApplicationDate), AgeGroup
ORDER BY 
    Year, AgeGroup;


-- 10. Aggregating Loan Approval Rates Based on Education Level (Yearly)
SELECT 
    YEAR(ApplicationDate) AS Year,
    EducationLevel,
    COUNT(*) AS TotalApplicants,
    AVG(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) AS LoanApprovalRate
FROM 
    Loan
GROUP BY 
    YEAR(ApplicationDate), EducationLevel
ORDER BY 
    Year, EducationLevel;
