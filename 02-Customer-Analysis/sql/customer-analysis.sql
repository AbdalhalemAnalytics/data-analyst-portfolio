    MIN(Total_Spent_EGP) AS min_spending,
    MAX(Total_Spent_EGP) AS max_spending
FROM customers
GROUP BY Preferred_Category
ORDER BY Preferred_Category;

-- Spending by city
SELECT
    City,
    COUNT(*) AS group_size,
    ROUND(AVG(Total_Spent_EGP), 2) AS mean_spending,
    MIN(Total_Spent_EGP) AS min_spending,
    MAX(Total_Spent_EGP) AS max_spending
FROM customers
GROUP BY City
ORDER BY City;


-- =========================================================
-- 9. CUSTOMER SEGMENTATION USING NTILE(4)
-- Q1 = lowest spending; Q4 = highest spending.
-- =========================================================

WITH ranked_customers AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY Total_Spent_EGP ASC) AS Spending_Quartile
    FROM customers
)
SELECT
    Spending_Quartile,
    COUNT(*) AS customer_count,
    ROUND(SUM(Total_Spent_EGP), 2) AS total_revenue_egp,
    ROUND(
        100.0 * SUM(Total_Spent_EGP) /
        (SELECT SUM(Total_Spent_EGP) FROM customers), 2
    ) AS revenue_share_pct,
    ROUND(100.0 * SUM(Churned_Flag) / COUNT(*), 2) AS churn_rate_pct
FROM ranked_customers
GROUP BY Spending_Quartile
ORDER BY Spending_Quartile DESC;


-- =========================================================
-- 10. CUSTOMER RANKING
-- =========================================================

SELECT
    Customer_ID,
    Total_Spent_EGP,
    RANK() OVER (ORDER BY Total_Spent_EGP DESC) AS spending_rank
FROM customers
ORDER BY spending_rank;


-- =========================================================
-- 11. CUSTOMER PROFILE BY AGE GROUP
-- =========================================================

SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS customer_count,
    ROUND(AVG(Total_Spent_EGP), 2) AS average_spending_egp,
    ROUND(100.0 * SUM(Churned_Flag) / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY age_group
ORDER BY age_group;


-- =========================================================
-- 12. SUPPORT TICKETS & CHURN
-- =========================================================

SELECT
    Support_Tickets,
    COUNT(*) AS customer_count,
    ROUND(AVG(Total_Spent_EGP), 2) AS average_spending_egp,
    ROUND(100.0 * SUM(Churned_Flag) / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Support_Tickets
ORDER BY Support_Tickets;


-- =========================================================
-- 13. DISCOUNT BEHAVIOR & CHURN
-- =========================================================

SELECT
    Discount_Orders_Pct,
    COUNT(*) AS customer_count,
    ROUND(AVG(Total_Spent_EGP), 2) AS average_spending_egp,
    ROUND(100.0 * SUM(Churned_Flag) / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Discount_Orders_Pct
ORDER BY Discount_Orders_Pct;


-- =========================================================
-- 14. SIGNUP AND LAST PURCHASE DATE TRENDS
-- =========================================================

SELECT
    strftime('%Y-%m', Signup_Date) AS signup_month,
    COUNT(*) AS new_customers
FROM customers
GROUP BY strftime('%Y-%m', Signup_Date)
ORDER BY signup_month;

SELECT
    strftime('%Y-%m', Last_Purchase_Date) AS last_purchase_month,
    COUNT(*) AS customers
FROM customers
GROUP BY strftime('%Y-%m', Last_Purchase_Date)
ORDER BY last_purchase_month;


-- =========================================================
-- END OF E-COMMERCE CUSTOMER ANALYSIS
-- =========================================================
