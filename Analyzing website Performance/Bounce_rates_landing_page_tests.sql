-- BUSINESS PROBLEM: Analyse landing page performance for a certain time period
-- Pulling Bounce rates for traffic landing on homepage. 3 main numbers .... SESSIONS, BOUNCED SESSIONS and BOUNCE RATE (% of Bounced sessions)
-- Step 1: finding the first website_pageview_id for each relevant session
-- Step 2: identifying the landing page of each session
-- Step 3: counting pageviews for each session, to identify "bounces" -> greater than 1 pageview
-- Step 4: summarizing total sessions and bounced sessions by landing page

USE mavenfuzzyfactory;
-- STEP 1 : part 1 
-- Finding the minimum website payview 
SELECT 
    website_sessions.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM
    website_pageviews
        INNER JOIN
    website_sessions ON website_sessions.website_session_id = website_pageviews.website_session_id
        AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY website_sessions.website_session_id;


-- Part 2: Creating a temporary table with min_pageview_id
Create temporary table first_pageviews_demo
SELECT 
    website_sessions.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM
    website_pageviews
        INNER JOIN
    website_sessions ON website_sessions.website_session_id = website_pageviews.website_session_id
        AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY website_sessions.website_session_id;

-- STEP 2:
-- Finding the landing page for each session
create temporary table sessions_w_landing_page_demo
SELECT 
    first_pageviews_demo.website_session_id,
    website_pageviews.pageview_url as landing_page
FROM
    first_pageviews_demo
        LEFT JOIN website_pageviews 
		ON first_pageviews_demo.min_pageview_id = website_pageviews.website_pageview_id;-- Website Pageview is the landing page view

-- Step 3 
-- Count of pageviews per session and then creating a temporary table for bounced sessions only
Create temporary table bounced_sessions_only
SELECT 
    sessions_w_landing_page_demo.website_session_id,
    sessions_w_landing_page_demo.landing_page,
    Count(website_pageviews.website_pageview_id) as count_of_pages_viewed
FROM sessions_w_landing_page_demo
LEFT JOIN website_pageviews ON sessions_w_landing_page_demo.website_session_id=website_pageviews.website_session_id
Group by sessions_w_landing_page_demo.website_session_id,
    sessions_w_landing_page_demo.landing_page
HAVING count(website_pageviews.website_pageview_id) =1 ; -- bounced sessions are sessions which have count of pageviews =1



-- Step 4: summarizing total sessions and bounced sessions by landing page
-- LEFT JOIN because returning a result from sessions_w_landing_page_demo and not bounced_sessions only because there is no match
-- if there is a bounced session we return the website_session_id else we return null thus allowing us to calculate bounce rates
SELECT 
    sessions_w_landing_page_demo.landing_page,
    COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id)/ COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id)  AS bounce_rate
FROM
    sessions_w_landing_page_demo
        LEFT JOIN
    bounced_sessions_only ON sessions_w_landing_page_demo.website_session_id = bounced_sessions_only.website_session_id
GROUP BY sessions_w_landing_page_demo.landing_page
ORDER BY 1;
    


