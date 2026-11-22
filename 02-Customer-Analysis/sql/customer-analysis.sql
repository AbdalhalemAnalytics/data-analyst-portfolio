
-- =====================================================
-- E-commerce Customer Analysis
-- Author: Abdalhalem Anwr Abdalhalem Abdalmalek
-- Database: PostgreSQL
-- Dataset: 100 E-commerce Customers
-- =====================================================

-- IMPORTANT:
-- Import the CSV into a table named:
-- ecommerce_customer_analysis_100
--
-- The queries below use the original column names.
-- Date columns are assumed to be stored as text
-- in DD/MM/YYYY format.

-- =====================================================
-- 1. DATA EXPLORATION
-- =====================================================

-- View all records
SELECT *
FROM ecommerce_customer_analysis_100;

-- Total number of customers
SELECT COUNT(*) AS total_customers
FROM ecommerce_customer_analysis_100;

-- Check duplicate customer IDs
SELECT
    "Customer_ID",
    COUNT(*) AS id_count
FROM ecommerce_customer_analysis_100
GROUP BY "Customer_ID"
HAVING COUNT(*) > 1;

-- Check missing values
SELECT
    COUNT(*) FILTER (WHERE "Customer_ID" IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE "Gender" IS NULL) AS missing_gender,
    COUNT(*) FILTER (WHERE "Age" IS NULL) AS missing_age,
    COUNT(*) FILTER (WHERE "City" IS NULL) AS missing_city,
    COUNT(*) FILTER (WHERE "Total_Orders" IS NULL) AS missing_orders,
    COUNT(*) FILTER (WHERE "Total_Spent_EGP" IS NULL) AS missing_spending,
    COUNT(*) FILTER (WHERE "Churned" IS NULL) AS missing_churn
FROM ecommerce_customer_analysis_100;

-- =====================================================
-- 2. CUSTOMER & SALES KPIs
-- =====================================================

SELECT
    COUNT(*) AS total_customers,
    SUM("Total_Orders") AS total_orders,
    ROUND(SUM("Total_Spent_EGP"), 2) AS total_revenue,
    ROUND(AVG("Total_Spent_EGP"), 2) AS average_spending,
    ROUND(
        CAST(PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY "Total_Spent_EGP") AS numeric), 2
    ) AS median_spending,
    ROUND(AVG("Total_Orders"), 2) AS average_orders
FROM ecommerce_customer_analysis_100;

-- =====================================================
-- 3. CUSTOMER ANALYSIS BY GENDER
-- =====================================================

SELECT
    "Gender",
    COUNT(*) AS customers,
    ROUND(AVG("Total_Spent_EGP"), 2) AS average_spending,
    SUM("Total_Orders") AS total_orders
FROM ecommerce_customer_analysis_100
GROUP BY "Gender"
ORDER BY customers DESC;

-- =====================================================
-- 4. CUSTOMER ANALYSIS BY CITY
-- =====================================================

SELECT
    "City",
    COUNT(*) AS total_customers,
    ROUND(AVG("Total_Spent_EGP"), 2) AS average_spending,
    SUM("Total_Orders") AS total_orders
FROM ecommerce_customer_analysis_100
GROUP BY "City"
ORDER BY total_customers DESC;

-- =====================================================
-- 5. PREFERRED PRODUCT CATEGORIES
-- =====================================================

SELECT
    "Preferred_Category",
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (), 2
    ) AS customer_percentage,
    ROUND(AVG("Total_Spent_EGP"), 2) AS average_spending
FROM ecommerce_customer_analysis_100
GROUP BY "Preferred_Category"
ORDER BY customer_count DESC;

-- =====================================================
-- 6. CUSTOMER CHURN ANALYSIS
-- =====================================================

SELECT
    "Churned",
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (), 2
    ) AS churn_percentage,
    ROUND(AVG("Total_Spent_EGP"), 2) AS average_spending,
    ROUND(AVG("Total_Orders"), 2) AS average_orders
FROM ecommerce_customer_analysis_100
GROUP BY "Churned"
ORDER BY customer_count DESC;

-- Churn by preferred category
SELECT
    "Preferred_Category",
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE "Churned" = 'Yes'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (WHERE "Churned" = 'Yes') * 100.0 /
        NULLIF(COUNT(*), 0), 2
    ) AS churn_rate
FROM ecommerce_customer_analysis_100
GROUP BY "Preferred_Category"
ORDER BY churn_rate DESC;

-- =====================================================
-- 7. DISCOUNT ANALYSIS
-- =====================================================

SELECT
    "Discount_Orders_Pct",
    COUNT(*) AS customer_count,
    ROUND(AVG("Total_Spent_EGP"), 2) AS average_spending,
    ROUND(AVG("Total_Orders"), 2) AS average_orders
FROM ecommerce_customer_analysis_100
GROUP BY "Discount_Orders_Pct"
ORDER BY "Discount_Orders_Pct";

-- =====================================================
-- 8. CUSTOMER SUPPORT ANALYSIS
-- =====================================================

SELECT
    "Support_Tickets",
    COUNT(*) AS customer_count,
    ROUND(AVG("Total_Spent_EGP"), 2) AS average_spending,
    COUNT(*) FILTER (
        WHERE "Churned" = 'Yes'
    ) AS churned_customers
FROM ecommerce_customer_analysis_100
GROUP BY "Support_Tickets"
ORDER BY "Support_Tickets";

-- =====================================================
-- 9. AGE GROUP ANALYSIS
-- =====================================================

SELECT
    CASE
        WHEN "Age" < 25 THEN 'Under 25'
        WHEN "Age" BETWEEN 25 AND 34 THEN '25-34'
        WHEN "Age" BETWEEN 35 AND 44 THEN '35-44'
        WHEN "Age" BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS customer_count,
    ROUND(AVG("Total_Spent_EGP"), 2) AS average_spending
FROM ecommerce_customer_analysis_100
GROUP BY age_group
ORDER BY age_group;

-- =====================================================
-- 10. CUSTOMER RANKING
-- =====================================================

SELECT
    "Customer_ID",
    "Total_Spent_EGP",
    RANK() OVER (
        ORDER BY "Total_Spent_EGP" DESC
    ) AS spending_rank
FROM ecommerce_customer_analysis_100
ORDER BY spending_rank;

-- =====================================================
-- 11. CUSTOMER SPENDING SEGMENTATION
-- =====================================================

SELECT
    "Customer_ID",
    "Total_Spent_EGP",
    NTILE(4) OVER (
        ORDER BY "Total_Spent_EGP" DESC
    ) AS spending_quartile
FROM ecommerce_customer_analysis_100
ORDER BY spending_quartile, "Total_Spent_EGP" DESC;

-- =====================================================
-- 12. DATE ANALYSIS
-- Dates are stored as DD/MM/YYYY text.
-- =====================================================

SELECT
    TO_DATE("Signup_Date", 'DD/MM/YYYY') AS signup_date,
    COUNT(*) AS customer_count
FROM ecommerce_customer_analysis_100
GROUP BY signup_date
ORDER BY signup_date;

SELECT
    TO_DATE("Last_Purchase_Date", 'DD/MM/YYYY')
        AS last_purchase_date,
    COUNT(*) AS customer_count
FROM ecommerce_customer_analysis_100
GROUP BY last_purchase_date
ORDER BY last_purchase_date;

-- =====================================================
-- END OF CUSTOMER ANALYSIS
-- =====================================================
