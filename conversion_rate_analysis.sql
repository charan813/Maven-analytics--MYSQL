SELECT 
    website_sessions.utm_content,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rt
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.website_session_id BETWEEN 1000 AND 2000
GROUP BY 1
ORDER BY 2 DESC;


/* Can use column number in our query for grouping!! 
SELECT 
    utm_content, COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
WHERE
    website_session_id BETWEEN 1000 AND 2000
GROUP BY 1
ORDER BY sessions DESC;*/