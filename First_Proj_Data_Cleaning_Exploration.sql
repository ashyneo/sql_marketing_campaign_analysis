-- SQL Project Data Cleaning & Exploration Step by Step:
SELECT *
FROM mktg_analysis 

/* Thought process: I need to think about the issues in my data. 
Missing values? 
Duplicates?
Null values?
Inconsistent formatting?
Impute, Ignore, or Remove missing rows?
*/

-- First I need to create a staging table so that the main file will not be affected.
CREATE TABLE analysis_cleaned AS 
SELECT * FROM mktg_analysis;

-- Check what are the unique values in VARCHAR columns:
SELECT DISTINCT common_keywords 
FROM analysis_cleaned 
ORDER BY 1 ASC;

-- Check what are the unique values in VARCHAR columns:
SELECT DISTINCT subscription_tier
FROM analysis_cleaned 
ORDER BY 1 ASC;

-- Findings: Formatting standardized. 

-- Generate a Summary Statistic for all numeric columns. Check for nulls, or strange values like outliers or negatives.
-- Let's start with budget column.
SELECT
    COUNT(budget) AS budget_non_null,
    COUNT(*) - COUNT(budget) AS budget_nulls,
    ROUND(AVG(budget)::NUMERIC, 2) AS budget_avg,
    MIN(budget) AS budget_min,
    MAX(budget) AS budget_max,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY budget) AS budget_median,
    ROUND(STDDEV_SAMP(budget)::NUMERIC, 2) AS budget_stdev
FROM analysis_cleaned;


-- Do the same for clicks, conversions, revenue_Generated, ROI, subscription length,, discount level, units sold, 
-- bundle price and customer satisfaction columns. (Numeric columns):
SELECT
    -- Clicks
    COUNT(clicks) AS clicks_non_null,
    COUNT(*) - COUNT(clicks) AS clicks_nulls,
    ROUND(AVG(clicks)::NUMERIC, 2) AS clicks_avg,
    MIN(clicks) AS clicks_min,
    MAX(clicks) AS clicks_max,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY clicks) AS clicks_median,
    ROUND(STDDEV_SAMP(clicks)::NUMERIC, 2) AS clicks_stdev,

    -- Conversions
    COUNT(conversions) AS conversions_non_null,
    COUNT(*) - COUNT(conversions) AS conversions_nulls,
    ROUND(AVG(conversions)::NUMERIC, 2) AS conversions_avg,
    MIN(conversions) AS conversions_min,
    MAX(conversions) AS conversions_max,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY conversions) AS conversions_median,
    ROUND(STDDEV_SAMP(conversions)::NUMERIC, 2) AS conversions_stdev,

    -- Revenue Generated
    COUNT(revenue_generated) AS revenue_generated_non_null,
    COUNT(*) - COUNT(revenue_generated) AS revenue_generated_nulls,
    ROUND(AVG(revenue_generated)::NUMERIC, 2) AS revenue_generated_avg,
    MIN(revenue_generated) AS revenue_generated_min,
    MAX(revenue_generated) AS revenue_generated_max,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue_generated) AS revenue_generated_median,
    ROUND(STDDEV_SAMP(revenue_generated)::NUMERIC, 2) AS revenue_generated_stdev,

    -- Return on Investment
    COUNT(return_on_investments) AS return_on_investments_non_null,
    COUNT(*) - COUNT(return_on_investments) AS return_on_investments_nulls,
    ROUND(AVG(return_on_investments)::NUMERIC, 2) AS return_on_investments_avg,
    MIN(return_on_investments) AS return_on_investments_min,
    MAX(return_on_investments) AS return_on_investments_max,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY return_on_investments) AS return_on_investments_median,
    ROUND(STDDEV_SAMP(return_on_investments)::NUMERIC, 2) AS return_on_investments_stdev,

    -- Subscription Length
    COUNT(subscription_length) AS subscription_length_non_null,
    COUNT(*) - COUNT(subscription_length) AS subscription_length_nulls,
    ROUND(AVG(subscription_length)::NUMERIC, 2) AS subscription_length_avg,
    MIN(subscription_length) AS subscription_length_min,
    MAX(subscription_length) AS subscription_length_max,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY subscription_length) AS subscription_length_median,
    ROUND(STDDEV_SAMP(subscription_length)::NUMERIC, 2) AS subscription_length_stdev,

    -- Discount Level
    COUNT(discount_level) AS discount_level_non_null,
    COUNT(*) - COUNT(discount_level) AS discount_level_nulls,
    ROUND(AVG(discount_level)::NUMERIC, 2) AS discount_level_avg,
    MIN(discount_level) AS discount_level_min,
    MAX(discount_level) AS discount_level_max,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY discount_level) AS discount_level_median,
    ROUND(STDDEV_SAMP(discount_level)::NUMERIC, 2) AS discount_level_stdev,

    -- Units Sold
    COUNT(units_sold) AS units_sold_non_null,
    COUNT(*) - COUNT(units_sold) AS units_sold_nulls,
    ROUND(AVG(units_sold)::NUMERIC, 2) AS units_sold_avg,
    MIN(units_sold) AS units_sold_min,
    MAX(units_sold) AS units_sold_max,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY units_sold) AS units_sold_median,
    ROUND(STDDEV_SAMP(units_sold)::NUMERIC, 2) AS units_sold_stdev,

    -- Bundle Price
    COUNT(bundle_price) AS bundle_price_non_null,
    COUNT(*) - COUNT(bundle_price) AS bundle_price_nulls,
    ROUND(AVG(bundle_price)::NUMERIC, 2) AS bundle_price_avg,
    MIN(bundle_price) AS bundle_price_min,
    MAX(bundle_price) AS bundle_price_max,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY bundle_price) AS bundle_price_median,
    ROUND(STDDEV_SAMP(bundle_price)::NUMERIC, 2) AS bundle_price_stdev,

    -- Customer Satisfaction
    COUNT(customer_satisfaction) AS customer_satisfaction_non_null,
    COUNT(*) - COUNT(customer_satisfaction) AS customer_satisfaction_nulls,
    ROUND(AVG(customer_satisfaction)::NUMERIC, 2) AS customer_satisfaction_avg,
    MIN(customer_satisfaction) AS customer_satisfaction_min,
    MAX(customer_satisfaction) AS customer_satisfaction_max,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY customer_satisfaction) AS customer_satisfaction_median,
    ROUND(STDDEV_SAMP(customer_satisfaction)::NUMERIC, 2) AS customer_satisfaction_stdev

FROM analysis_cleaned;

-- Findings: Nothing out of the ordinary. No missing value detected for all numeric columns.

-- Check for Duplicate rows on all Unique Identifiers.
SELECT
campaign_id,
product_id,
customer_id,
flash_sale_id,
bundle_id, 
COUNT(*) AS occurence_count
FROM analysis_cleaned
GROUP BY campaign_id, product_id, customer_id, flash_sale_id, bundle_id
HAVING COUNT(*) > 1;

-- Findings: No duplicate found in each unique identifier columns. Good.

-- Exploration: Which campaign generated the highest ROI?
SELECT
campaign_id,
return_on_investments
FROM analysis_cleaned
ORDER BY return_on_investments DESC
LIMIT 10;

-- Findings: There were 10 campaigns that had the highest ROI of 5. 

-- Exploration 2: Do premium subscribers generate more revenue per campaign than basic ones?
SELECT
subscription_tier,
ROUND(AVG(revenue_generated)::numeric, 2) AS avg_revenue_per_campaign
FROM analysis_cleaned
GROUP BY subscription_tier
ORDER BY avg_revenue_per_campaign DESC;

-- Findings: Surprisingly, no.... The average revenue for Basic is 50,157.92. Premium 50,093.14. Standard: 49,860.90.
-- Apparently, Basic tier generated slightly more revenue than Premium tiers on average.


-- Exploration 3: The number of clicks per conversion. What is the average number of clicks required to achieve a single conversion?
-- I will add a new column by aggregating clicks and conversions columns.
ALTER TABLE analysis_cleaned
ADD COLUMN clicks_per_conversion NUMERIC;

-- Populate the new column with my aggregation:
UPDATE analysis_cleaned
SET clicks_per_conversion = clicks / conversions
WHERE conversions IS NOT NULL AND conversions <>0;

-- Now, which campaigns are more efficient in converting clicks into desired actions?
-- I will note that those campaigns with lower average clicks per conversions are more efficient, which means fewer clicks help achieve more conversions.
SELECT 
  campaign_id,
  SUM(clicks) AS total_clicks,
  SUM(conversions) AS total_conversions,
  ROUND(SUM(clicks)::numeric / NULLIF(SUM(conversions), 0), 2) AS avg_clicks_per_conversion
FROM analysis_cleaned
GROUP BY campaign_id
ORDER BY avg_clicks_per_conversion ASC;
-- Findings: campaign CMP_MY63GT had total of 15 clicks, and 974 conversions. That's very efficient and good.
-- But why is it that there were more conversions than clicks?
-- Could it be a single user click resulting in many conversions?
/* Users sharing the same URL or saving it after clicking on an ad? Sometimes subsequent visits using the same
URL results in just 1 clicks but multiple conversions? Is the click from influencer marketing sharing the same link to fans?
This is something we need to clarify with the marketing campaign team to get an absolute answer.
Afterall, this could be a grey area because we do not know what conversions here imply. It could be clicking the next page, or even purchases, or any desired outcome the business wants.
*/

-- Exploration 4: Analyse ROI and Conversions by the discount levels:
-- I want to use CTE to analyse this query even further such as the max avg_conversions created within query:
WITH Analyse_ROI AS
(
SELECT
discount_level,
ROUND(AVG(return_on_investments)::numeric, 2) AS average_roi,
ROUND(AVG(conversions)::numeric, 2) AS avg_conversions,
MAX(return_on_investments) AS max_roi,
MAX(conversions) AS max_conversions
FROM analysis_cleaned
GROUP BY discount_level
ORDER BY discount_level
)
SELECT *
FROM Analyse_ROI;
-- Findings: A quick look showed that there is no significance / correlation between discount levels and avg_roi and avg_conversions respectively.
-- This is due to that even when discount levels are at 69%, average roi is about the same at 2.5 throughout, similar to avg_conversions which fluctuates around 400~500 range throughout all levels.
-- The max_roi and max_conversions provide the raw value as reference.

-- Exploration 5: Identify optimal discount ranges:
-- I want to determine which discount ranges yield highest ROI and conversions:
-- Will use a CASE statement to categorise discount percentages into ranges and grouping them.
SELECT
CASE
WHEN discount_level < 10 THEN '0-9%'
WHEN discount_level BETWEEN 10 AND 19 THEN '10-19%'
WHEN discount_level BETWEEN 20 AND 29 THEN '20-29%'
WHEN discount_level BETWEEN 30 AND 39 THEN '30-39%'
WHEN discount_level BETWEEN 40 AND 49 THEN '40-49%'
ELSE '50%+'
END AS discount_range,
ROUND(AVG(return_on_investments)::numeric, 2) AS average_roi,
ROUND(AVG(conversions)::numeric, 2) AS avg_conversions
FROM analysis_cleaned
GROUP BY discount_level
ORDER BY discount_level;
-- Will export this query results to Tableau for more intuitive analysis.


SELECT
  CASE
    WHEN discount_level < 10 THEN '0-9%'
    WHEN discount_level BETWEEN 10 AND 19 THEN '10-19%'
    WHEN discount_level BETWEEN 20 AND 29 THEN '20-29%'
    WHEN discount_level BETWEEN 30 AND 39 THEN '30-39%'
    WHEN discount_level BETWEEN 40 AND 49 THEN '40-49%'
    ELSE '50%+'
  END AS discount_range,
  ROUND(AVG(return_on_investments)::numeric, 2) AS average_roi,
  ROUND(AVG(conversions)::numeric, 2) AS avg_conversions
FROM analysis_cleaned
GROUP BY
  CASE
    WHEN discount_level < 10 THEN '0-9%'
    WHEN discount_level BETWEEN 10 AND 19 THEN '10-19%'
    WHEN discount_level BETWEEN 20 AND 29 THEN '20-29%'
    WHEN discount_level BETWEEN 30 AND 39 THEN '30-39%'
    WHEN discount_level BETWEEN 40 AND 49 THEN '40-49%'
    ELSE '50%+'
  END
ORDER BY discount_range;
-- The above findings seggregates discount levels into categories (with each summed). Each discount ranges have somewhat similar / close average conversions, with 30-39% generating
-- the most average conversions. There seem to be no significant relationship between level of discounts and ROI / conversion rates.

-- Exploration 5: Let's analyze the bundle sales by price points. Which bundle_id generates the most sales?
SELECT
bundle_id,
bundle_price,
SUM(units_sold) AS total_units_sold -- We sum, for in case there are multiple records of bundle_id in the column. Getting the total of each is crucial.
FROM analysis_cleaned
WHERE bundle_id IS NOT NULL
GROUP BY bundle_id, bundle_price
ORDER BY bundle_price;  -- It's best to order by bundle_price to assess how different prices affect the performance of sales.
-- Findings: A brief look showed no significant correlation between the 2, but putting into tableau will give a better picture. 
-- Reason: Prices of around $50 affect the number of units sold differently. Some sold 196 units, some 17, some 75, they are not consistent. 
-- Perhaps it's best to understand from the marketing department what these bundle products are, and perhaps the units sold are based on product quality instead of price. (Price insensitive consumers)


-- Exploration 6: Evaluate Customer Satisfaction across bundle price ranges:
-- I will assess how customer satisfaction vary across the different bundle price range, we could uncover optimal pricing strategies.

-- I plan to use a CASE statement to categorise bundle prices. I need to know the min and max of bundle_prices.
SELECT
MIN(bundle_price),
MAX(bundle_price)
FROM analysis_cleaned
-- Result: min $50.01, max: $499.97

SELECT
CASE
WHEN bundle_price < 100 THEN 'Below $100'
WHEN bundle_price BETWEEN 100 AND 199 THEN '$100 - $199'
WHEN bundle_price BETWEEN 200 AND 299 THEN '$200 - $299'
ELSE 'Above $300+'
END AS price_range,
ROUND(AVG(customer_satisfaction)::numeric, 2) AS avg_satisfaction
FROM analysis_cleaned
WHERE bundle_id IS NOT NULL
GROUP BY price_range
ORDER BY price_range;
-- Findings: Interestingly, the average customer satisfaction fluctuates around 2.51 ~ 2.54 for all price ranges. 
-- This means that the business' products is likely not driven by prices. Consumers are likely price insensitive and value other qualities of the products or service, since average satisfaction remained at 2.5 even for prices above $300.

-- Exploration 7: Is there any correlation between campaign keywords and conversion rates?

SELECT 
TRIM(UNNEST(STRING_TO_ARRAY(common_keywords, ','))) AS keyword,   -- While this step is not necessary but just to put into practice on how to split delimiters like commas
ROUND(AVG(conversions), 2) AS avg_conversions
FROM analysis_cleaned
WHERE common_keywords IS NOT NULL
GROUP BY keyword
ORDER BY avg_conversions DESC;
-- Findings: Customers who found the product Innovative usually had higher conversions, followed by Durable, Stylist, and Affordable.
-- Although the average conversion rates are somewhat closely clustered, this again buttress the analysis that the business' consumer base are price insensitive and value
-- innovation and durability more.


-- Exploration 8: Additional exploration of relationship between bundle price, units sold and average satisfaction rate.
SELECT
bundle_id,
bundle_price,
SUM(units_sold) AS total_units_sold,
ROUND(AVG(customer_satisfaction)::numeric, 2) AS avg_satisfaction
FROM analysis_cleaned
WHERE bundle_id IS NOT NULL
GROUP BY bundle_id, bundle_price
ORDER BY avg_satisfaction DESC;
-- Findings: The highest satisfaction is 5, and surprisingly satisfaction scores were only 4.0. This means there were no perfectly satisfied customers.
-- A trend analysis should be done on Tableau to see if total units sold were actually related to price differences or average satisfaction rates.
