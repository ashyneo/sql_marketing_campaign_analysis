# Introduction
📊 Here, I dove into analyzing marketing campaign performance data!
In this project, I focused on data cleaning and exploratory data analysis (EDA) — such as identifying 💰 top-performing campaigns by revenue and conversions, and exploring 📈 statistical correlations that might explain what drives their success.

🔍 Check out my SQL Queries here: [View Marketing Analysis SQL](First_Proj_Data_Cleaning_Exploration.sql)

Essential sql steps required for postgresql on vscode: [Essential Sql Steps](First_Project_SQL_Ash.session.sql)

# Background
Driven by the quest to evaluate campaign efficiency, product sales, and customer engagement that replicates real-life scenarios, this dataset was created synthetically to allow for a comprehensive analysis of a marketing campaign performance.

Data is extracted from [Kaggle Dataset](https://www.kaggle.com/datasets/imranalishahh/marketing-and-product-performance-dataset). It's packed with insights on campaign performance, product details, customer insights, and promotional context like discount levels and common keywords by consumers.

### The questions I wanted to answer through my SQL queries were:

1. Which campaign generated the highest return on investment (ROI)?
2. Do premium subscriptions generate more revenue compared to basic ones?
3. What is the average number of clicks required to achieve a single conversion?
4. Analyse the ROI and Conversions by discount levels. Any interesting insights found?
5. What is the optimal discount ranges that yields the highest ROI and conversions?
6. Which product bundles generate the most sales?
7. How does the customer satisfaction levels vary across different price range?
8. Are there any correlation between certain campaign keywords and conversion rates?


# Tools I Used
For my deep dive into the marketing campaign performance, I harnessed the power of several key tools:

- **SQL:** Used to extract and analyze data, forming the foundation of key insights.
- **PostgreSQL:** Chosen for its robustness in managing the job posting dataset.
- **Visual Studio Code:** Primary tool for writing and executing SQL queries.
- **Git & GitHub:** Employed for version control and sharing scripts, supporting collaboration and tracking project progress.
  

# The Analysis
Each query for this project aims at investigating specific aspects of the marketing campaign performance. I cleaned the data before conducting exploratory data analysis (EDA). Specifically, I first created a staging table and looked at **missing values, duplicates, null values, inconsistent formatting** by generating a summary statistic to identify these issues.

I ensured the table is clean before beginning the necessary EDA for each question.

Here’s how I approached each question:

### 1. Top Campaigns with the Highest ROI
To identify which are the top 10 campaigns that generated the highest ROI, I filtered the relevant campaign ids by their ROI, ordering by the top 10 best performing campaigns. This query highlights the best campaigns with the highest ROI.

```sql
SELECT
campaign_id,
return_on_investments
FROM analysis_cleaned
ORDER BY return_on_investments DESC
LIMIT 10;
```
Here's the breakdown of what I found:
- **Multiple Excellent Performing Campaigns:** All 10 campaigns had the maximum ROI of 5.0, indicating many campaigns with great track record of success.
- **Success of these Campaigns:** These campaigns include CMP_2GQ60B, CMP_5590UQ, CMP_U44WCH can be further evaluated with the marketing team to understand nd ensure future campaign success.
  
  
<img width="376" alt="image" src="https://github.com/user-attachments/assets/407f0982-3249-42b1-a07d-1c661b9cbe25" />

*Screenshot of the output of the top performing campaigns*

### 2. Does Premium Subscription = Greater Revenue?
To understand whether Premium subscriptions correlate with greater revenue, I wrote a SQL query to aggregate the average revenue per campaign and group the results with subscription tier. This will show me a brief overview of the three subscription tiers and the average revenue generated to allow for comparison. 
```sql
SELECT
subscription_tier,
ROUND(AVG(revenue_generated)::numeric, 2) AS avg_revenue_per_campaign
FROM analysis_cleaned
GROUP BY subscription_tier
ORDER BY avg_revenue_per_campaign DESC;
```
Here's the breakdown of each subscription tier and the respective average revenue earned:
- **Basic** is leading with an average revenue earned of $50,157.92.
- **Premium** follows closely with an average revenue earned of $50,093.14.
- **Standard** is also highly sought after, with an average revenue earned of $49,860.90.
Interestingly, higher subscription tiers does not lead to greater revenue, as the demand for Basic tier led the highest revenue earned across each tier. This may indicate either a larger customer base in Basic tier, or a higher retention efficiency at a lower price point. Focusing or upselling within the Basic tier could have a high ROI impact.

![image](https://github.com/user-attachments/assets/1ada86c0-c991-437b-9b6b-09693eb8bcea)


*Bar graph visualizing the average revenues of each subscription tiers. Utilised AI to generate this graph from my SQL query results*

### 3. Top Most Efficient Campaigns in Converting Clicks into Conversions

This query helped identify the most efficient campaigns in generating the most conversions per average clicks. The campaign with highest conversions with lowest average clicks are the best.

```sql
ALTER TABLE analysis_cleaned
ADD COLUMN clicks_per_conversion NUMERIC;

-- Populate the new column with my aggregation:
UPDATE analysis_cleaned
SET clicks_per_conversion = clicks / conversions
WHERE conversions IS NOT NULL AND conversions <>0;

SELECT 
  campaign_id,
  SUM(clicks) AS total_clicks,
  SUM(conversions) AS total_conversions,
  ROUND(SUM(clicks)::numeric / NULLIF(SUM(conversions), 0), 2) AS avg_clicks_per_conversion
FROM analysis_cleaned
GROUP BY campaign_id
ORDER BY avg_clicks_per_conversion ASC;
```
Here's the breakdown of the most efficient campaigns in converting clicks into desired actions:
- The top 5 campaigns show a surprisingly high conversion-to-click ratio, where conversions outnumber clicks significantly.
- **CMP_MY63GT** campaign recorded only 15 clicks but achieved 974 conversions, leading to 0.02 clicks per conversion. This suggests multiple clicks per conversion, which could possibly be:
- **One user generating many conversions through multiple product purchases in one session.**
- **Shared links (e.g. from influencers' links or referral campaigns) where the original user click is tracked, which could result in unconventional conversion tracking.**

| campaign_id   | total_clicks | total_conversions | avg_clicks_per_conversion |
|----------|--------------|----------------|--------------------------------|
| CMP_MY63GT      | 15         | 974          | 0.02  |
| CMP_HRX2CJ    | 17         | 738          | 0.02  |
| CMP_9HV1Z0   | 19         | 866          | 0.02|
| CMP_A5FCUZ  | 13         | 656          | 0.02   |
| CMP_FAZ4X3 | 19         | 780          | 0.02       |

*Table of the top 5 campaigns with highest average clicks per conversion in analysis_cleaned table.*

### 4. Does discount levels have an impact on ROI and Conversions?
Exploring the average ROI and Conversions to see if there are any correlation with the level of discounts. I used a Common Table Expression (CTE) to analyse the results further using MAX aggregations within the CTE.

```sql
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
```
Key Insights derived from the above query:
- **No Strong Correlation Detected:** Despite expectations, there is **no clear relationship** between discount levels and:
  - **Average ROI** – remains relatively stable, fluctuating around **2.5** even at high discount levels (e.g., 69%).
  - **Average Conversions** – consistently hovers between **400 to 500 conversions** across most discount tiers.

- **Max Values as Performance Extremes:** The **`max_roi`** and **`max_conversions`** columns provide helpful context on campaign potential but don't reflect the average campaign experience. These are interpreted as **outliers or peak performance cases**.
- Offering steeper discounts does **not necessarily guarantee better ROI or higher average conversions**. This insight can guide future campaigns to **avoid over-discounting**, which could possibly erode profitability without delivering proportional performance gains. Instead, the focus may be better placed on optimizing other campaign factors like targeting, ad creative, or timing.


| Discount Level (%) | Average ROI | Avg. Conversions | Max ROI | Max Conversions |
|--------------------|-------------|------------------|---------|------------------|
| 10                 | 2.72        | 533.44           | 4.97    | 993              |
| 11                 | 2.76        | 471.09           | 4.98    | 995              |
| 12                 | 2.74        | 491.13           | 4.99    | 984              |
| 13                 | 2.75        | 509.10           | 4.99    | 998              |
| 14                 | 2.70        | 514.75           | 5.00    | 994              |	
| ...                 | ...        | ...              | ...     | ...              |	
| 69                 | 2.62        | 519.05           | 4.99    | 998              |	

*Table of the average and maximum ROI, Conversions for the discounts 10% to 14%. Note: The summary is based on a broader dataset spanning discount levels from 10% to 69%.*

### 5. What is the Optimal Discount Range?

To determine which discount range yield the highest ROI and Conversions, I will use a CASE statement to categorise the discount percentages into ranges and group them for a better view.

```sql
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
```

| discount range | average ROI     | avg_conversions | 
|----------|------------|--------------|
| 10--19%        | 2.71         | 499.04           |      
| 20--29%     | 2.74 | 507.94           |           
| 30--39%       | 2.79     | 510.99           |           
| 40--49%       | 2.80  | 489.84           |           
| 50%+      | 2.75      | 492.78           |           

*Table of categorised discount range sorted by average ROI and Conversions.*

📝 Key Findings: 
- **Most Efficient**: The 30-39% discount range generated the highest average convsions at 510.99, closely followed by the 20-29% range.
- **Interesting Insight**: The 40-49% discount range had some potential where it edges out in ROI (2.80), but sees lower conversions at 489.84. This suggests that pushing discounts too high does not necessarily lead to better performance.
- **Recommendation**: Discount levels between 30-39% offers a solid balance and sweet spot in attracting customers and maintaining strong returns, making it an optimal choice when planning for future campaigns.


### 6. Product Bundle Price vs Sales Performance

To explore whether pricing impacts sales performance, I wrote the SQL query below to sort bundles by their 'bundle_price' and looked at how many units were sold per price point.

```sql
SELECT
bundle_id,
bundle_price,
SUM(units_sold) AS total_units_sold -- We sum, for in case there are multiple records of bundle_id in the column. Getting the total of each is crucial.
FROM analysis_cleaned
WHERE bundle_id IS NOT NULL
GROUP BY bundle_id, bundle_price
ORDER BY bundle_price; 
```

| bundle_id     | bundle_price | total_units_sold |
|---------------|--------------|------------------|
| BNDL_0XS0R8   | 50.01        | 196              |
| BNDL_RR64XT   | 50.06        | 17               |
| BNDL_5IHIT1   | 50.09        | 75               |
| BNDL_SDJB4Q   | 50.14        | 146              |
| BNDL_YNBZJT   | 50.14        | 30               |
| BNDL_E7EXIK   | 50.26        | 58               |
| BNDL_HXX6J3   | 50.32        | 133              |
| BNDL_RZPVOG   | 50.40        | 15               |
| BNDL_J5TLHX   | 50.49        | 149              |
| BNDL_Y0A455   | 50.53        | 14               |

*Table of Top Bundle Prices vs Units Sold. Rows extend up to 10,000 rows.*

What I Found:
- **No Clear or Consistent Correlation**: Despite prices hovering around $50, the number of units sold varies significantly from as low as 14 to nearly 200. This suggests that there is no clear or consistent correlation between the price and sales volume at the price point alone.
- **Potential Things to Look At**: However, the incosnsitency might point to factors that are not price related, such as product quality / appeal, marketing efforts, or bundle contents or brand associations.
- **Recommendations**: Since the output extents to 10,000 rows, it would be helpful to visualise this correlation in depth using a scatterplot. It would also be useful to consult the marketing or product teams to better understand:
  - What each bundle actually contains?
  - Are some bundles were promoted more heavily?
  - If some bundles appeal to different customer segments (e.g., price-insensitive vs budget shoppers)?
  - Using a scatterplot to provide better insight into trends / clusters potentially? (No outliers since data was cleaned beforehand)


### 7. How Does Customer Satisfaction Vary Across Different Bundle Price Range?

To explore how customer satisfaction scores (measured after refunds, on a scale of 1 to 5 with 5 being most satisfied) are impacted by bundle price range. I wrote a CASE statement to categorise the respective bundle price range after calculating the minimum and maximum bundle prices.

```sql
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
```


| Price Range       | Average Satisfaction |
|-------------------|----------------------|
| $100 – $199       | 2.51                 |
| $200 – $299       | 2.47                 |
| Above $300+       | 2.50                 |
| Below $100        | 2.54                 |

*Table of Average Customer Satisfaction Scores by Bundle Price Range.*

Insight Derived:
- **Relatively Stable Scores**: Customer satisfaction scores remain relatively consistent across the different price ranges, fluctuating only slightly between 2.47 and 2.54.
- **Pricing Not A Major Driver of Satisfaction**: It appears that pricing does not appear to drive customer satisfaction. Even products priced above $300 received a similar satisafction score to lower-priced bundles. Hence, customers may be **more influenced by product quality, brand experience, or service** rather than price alone, indicating a likely **price insensitive** or **value-driven** customer base.


### 8. Does Certain Campaign Keyword Impact Conversion Rates?

Finally, I want to find out if certain things consumers say have any influence or correlation on conversion. 

```sql
SELECT 
  TRIM(UNNEST(STRING_TO_ARRAY(common_keywords, ','))) AS keyword,
  COUNT(*) AS keyword_count,
  ROUND(AVG(conversions), 2) AS avg_conversions
FROM analysis_cleaned
WHERE common_keywords IS NOT NULL
GROUP BY keyword
ORDER BY avg_conversions DESC;
```

| **Keyword**   | **Average Conversions** | **Keyword Count** |
|---------------|--------------------------|--------------------|
| Innovative    | 507.70                   | 2,491              |
| Durable       | 504.60                   | 2,436              |
| Stylish       | 494.33                   | 2,514              |
| Affordable    | 489.71                   | 2,559              |

*Results Table of Consumer Keywords frequency and Average Conversions.*

Insights Found:
- **Innovative**: This keyword yielded the highest average conversions (507.70) suggesting that consumers are more responsive to campaigns emphasizing innovations.
- **Durable** and **Stylish**: These keywords followed closely behind, indicating that product reliability and aesthetic appeal also positively influence conversions.
- **Affordable**: Despite affordability being the most mentioned keyword, it has the lowest average conversions. This could imply that affordability alone is not a strong conversion driver, which further buttress my analysis in [Question 7](#7-how-does-customer-satisfaction-vary-across-different-bundle-price-range) that pricing is not a major driver of satisfaction.


# What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **🧩 Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **📊 Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **💡 Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
