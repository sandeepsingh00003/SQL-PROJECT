WITH two_vehicle AS (
    SELECT 
        m.maker,
        d.fiscal_year,
        SUM(m.electric_vehicles_sold) AS total_sold
    FROM electric_vehicle_sales_by_makers m
    JOIN dim_date d ON m.date = d.date
    WHERE m.vehicle_category = '2-Wheelers' 
      AND d.fiscal_year IN (2023, 2024)
    GROUP BY m.maker, d.fiscal_year
)
SELECT fiscal_year, maker, total_sold,
       CASE 
           WHEN rank_desc <= 3 THEN 'Top 3'
           WHEN rank_asc <= 3 THEN 'Bottom 3'
           ELSE NULL
       END AS category
FROM (
    SELECT fiscal_year, maker, total_sold,
           RANK() OVER (PARTITION BY fiscal_year
           ORDER BY total_sold DESC) AS rank_desc,
           RANK() OVER (PARTITION BY fiscal_year
           ORDER BY total_sold ASC) AS rank_asc
    FROM two_vehicle
) RankedMarkets
WHERE rank_desc <= 3 OR rank_asc <= 3
ORDER BY fiscal_year, rank_desc;
