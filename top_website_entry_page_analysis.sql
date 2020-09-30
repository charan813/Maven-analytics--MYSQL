-- FINDING THE TOP WEBSITE PAGES
SELECT 
    website_pageviews.pageview_url,
    COUNT(DISTINCT website_pageview_id) AS pageview_count
FROM
    website_pageviews
WHERE
    created_at < '2012-06-09'
GROUP BY website_pageviews.pageview_url
ORDER BY pageview_count DESC;

-- FINDING THE TOP ENTRY/ LANDING PAGES
-- Step 1: find the first pageview for each session
-- Step 2 : counting number of sessions for each landing page
CREATE Temporary table landing_per_session
SELECT 
    website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS first_landing_page
FROM
    website_pageviews
WHERE
    created_at < '2012-06-12'
GROUP BY website_pageviews.website_session_id;

SELECT 
    website_pageviews.pageview_url AS landing_page_url,
    COUNT(DISTINCT landing_per_session.website_session_id) AS sessions_hitting_landing_page
FROM
    landing_per_session
        LEFT JOIN
    website_pageviews ON landing_per_session.first_landing_page = website_pageviews.website_pageview_id
WHERE
    created_at < '2012-06-12'
GROUP BY website_pageviews.pageview_url
ORDER BY 2 DESC;