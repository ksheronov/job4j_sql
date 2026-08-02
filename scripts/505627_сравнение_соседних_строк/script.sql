WITH daily_sales AS (
    SELECT
        DATE (o.created_at)AS sale_date,
        SUM(oi.quantity * oi.unit_price) AS sales_amount
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY DATE (o.created_at)
)
SELECT
    sale_date,
    sales_amount,
    LAG(sales_amount) OVER w AS previous_day_sales,
    LEAD(sales_amount) OVER w AS next_day_sales,
    sales_amount - LAG(sales_amount) OVER w AS sales_diff,
    SUM(sales_amount) OVER w AS running_total,
    AVG(sales_amount) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg_last_three_days
FROM daily_sales
WINDOW	w  AS (ORDER BY sale_date)
ORDER BY sale_date ASC