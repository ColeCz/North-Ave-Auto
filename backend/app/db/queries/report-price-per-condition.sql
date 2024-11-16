– Get base stats for each vehicle type & condition
WITH price_stats AS (
	SELECT
v.vehicle_type, p.condition, ROUND(AVG(t.trans_price) AS avg_price
FROM Vehicle v
JOIN Transactions t ON v.vin = t.vehicle_vin
JOIN Purchase p ON t.trans_id = p.transactions
GROUP BY v.vehicle_type, p.condition
)

– Create pivoted report (using COALESCE to return 0 in cases where there may be NULL values)
SELECT
vehicle_type,
COALESCE(MAX(CASE WHEN condition = 'poor' THEN avg_price END), 0) AS poor_condition,
COALESCE(MAX(CASE WHEN condition = 'good' THEN avg_price END), 0) as good_condition,
COALESCE(MAX(CASE WHEN condition = 'excellent' THEN avg_price END), 0) as excellent_condition
FROM price_stats
GROUP BY vehicle_type
ORDER BY vehicle_type;
