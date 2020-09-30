#Trending with Granular Segments 
SELECT MIN(date(website_sessions.created_at)) AS week_start_date,
    COUNT(DISTINCT CASE
            WHEN website_sessions.device_type = 'desktop' THEN website_sessions.website_session_id
            ELSE NULL
        END) AS dtop_sessions,
    COUNT(DISTINCT CASE
            WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id
            ELSE NULL
        END) AS mobile_sessions
FROM
    website_sessions
WHERE
    website_sessions.created_at > '2012-04-15'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY YEAR(website_sessions.created_at),
    WEEK(website_sessions.created_at)