/* Group Customers into 3 segments based on thier spending behaviour :
- VIP : Customers with at least 12 months of history and spending more than $5000.
- Regular : Customers with at least 12 months of history BUT spending equal to or less than $5000.
- New: Customers with lifespan less than 12 months
And find the total number of customers by each group
*/

SELECT 
customer_segment,
COUNT(customer_key)


FROM(
SELECT 
c.customer_key,
SUM(f.sales_amount) AS total_spending,
MIN (order_date) AS first_order,
MAX (order_date) AS last_order,
DATEDIFF(month,MIN (order_date),MAX (order_date)) AS lifespan,
CASE WHEN DATEDIFF(month,MIN (order_date),MAX (order_date)) > 12 AND SUM(f.sales_amount) > 5000 THEN 'VIP'
     WHEN DATEDIFF(month,MIN (order_date),MAX (order_date)) > 12 AND SUM(f.sales_amount) <= 5000 THEN 'Regular'
     ELSE  'New'
END AS customer_segment
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)T
GROUP BY customer_segment
