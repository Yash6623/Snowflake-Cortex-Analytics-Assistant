--1. Create Warehouse
CREATE WAREHOUSE IF NOT EXISTS ANALYST_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE;
CREATE DATABASE IF NOT EXISTS ANALYST_DB;
CREATE SCHEMA IF NOT EXISTS ANALYST_DB.SALES;

-- 2. Create tables

CREATE OR REPLACE TABLE ANALYST_DB.SALES.CUSTOMERS (
  CUSTOMER_ID INT,
  CUSTOMER_NAME STRING,
  REGION STRING
);
CREATE OR REPLACE TABLE ANALYST_DB.SALES.PRODUCTS (
  PRODUCT_ID INT,
  PRODUCT_NAME STRING,
  CATEGORY STRING
);
CREATE OR REPLACE TABLE ANALYST_DB.SALES.SALESP (
  ORDER_ID INT,
  CUSTOMER_ID INT,
  PRODUCT_ID INT,
  ORDER_DATE DATE,
  QUANTITY INT,
  SALES_AMOUNT NUMBER(10,2)
);

-- 3. Insert sample data

INSERT INTO CUSTOMERS VALUES
(1, 'Amazon', 'North America'),
(2, 'Walmart', 'North America'),
(3, 'Flipkart', 'Asia');

INSERT INTO PRODUCTS VALUES
(101, 'Laptop', 'Electronics'),
(102, 'Phone', 'Electronics'),
(103, 'Desk', 'Furniture');

INSERT INTO SALESP VALUES
(1001, 1, 101, '2024-06-01', 5, 5000),
(1002, 2, 102, '2024-06-05', 10, 7000),
(1003, 3, 103, '2024-06-10', 3, 1500);

-- 4. Natural language → SQL (Cortex LLM)


SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'mistral-large',
  'Generate SQL for Snowflake tables SALES and PRODUCTS
   to find top 3 products by total sales amount'
);
-- 5. Final SQL answer

SELECT p.product_name,
       SUM(s.sales_amount) AS total_sales
FROM SALESP s
JOIN PRODUCTS p
  ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 3;


