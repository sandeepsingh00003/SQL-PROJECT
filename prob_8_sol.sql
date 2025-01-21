WITH monthly_sales AS (
 SELECT 
    MONTHNAME(STR_TO_DATE(date, '%d-%b-%y')) AS month_name,
    SUM(electric_vehicles_sold) AS total_ev_sales
FROM 
    electric_vehicle_sales_by_state
WHERE 
    YEAR(STR_TO_DATE(date, '%d-%b-%y')) BETWEEN 2022 AND 2024
GROUP BY 
      month_name
ORDER BY 
    total_ev_sales DESC

)

SELECT 
    month_name,
    SUM(total_ev_sales) AS total_ev_sales
FROM 
    monthly_sales
GROUP BY 
    month_name
ORDER BY 
    total_ev_sales DESC;