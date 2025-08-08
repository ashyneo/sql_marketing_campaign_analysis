# Marketing Campaign Analysis: SQL Insights Report
**Note:** This README provides a more **concise**, high level overview to help readers quickly grasp my project's intent, key findings, and outcomes.

For the full step-by-step technical README, including **SQL queries, data cleaning process, in-depth EDA, and my entire thought process**, [Click here](https://github.com/ashyneo/sql_marketing_campaign_analysis/blob/main/README-2.md).

**Full Code:** [Click Here](https://github.com/ashyneo/sql_marketing_campaign_analysis/blob/main/First_Proj_Data_Cleaning_Exploration.sql)

This project demonstrates my skills in data extraction and exploratory analysis using PostgreSQL on Visual Studio Code, focusing on uncovering meaningful marketing insights such as ROI, conversions, and customer satisfaction trends.
While the core analysis was performed entirely through SQL queries, I utilised other tools to generate graphs to better communicate the findings.

---

## 📌 Overview

The analysis focuses on identifying:
- High-performing campaigns worth replicating
- Effective discount ranges for maximizing ROI and conversions
- Pricing strategies that influence sales volume and satisfaction
- Keywords that drive consumer engagement


---


## 📈 Visuals & Findings

### 1. Top Campaigns with Highest ROI

_**Insight:**_ All 10 campaigns analyzed achieved the **maximum ROI of 5.0**, demonstrating multiple highly successful campaigns. Notably, campaigns like **CMP_2GQ60B**, **CMP_5590UQ**, and **CMP_U44WCH** stand out and are strong candidates for replication and deeper marketing review.


<img width="376" alt="image" src="https://github.com/user-attachments/assets/407f0982-3249-42b1-a07d-1c661b9cbe25" />

*Screenshot of the output of the top performing campaigns*

---

### 2. Average Revenue by Subscription Tier
_**Insight:**_ Contrary to expectations, the **Basic subscription tier leads with the highest average revenue of $50,157.92**, followed closely by Premium and Standard tiers. This suggests a larger or more loyal customer base within Basic, highlighting opportunities to focus upselling and retention efforts there.

![image](https://github.com/user-attachments/assets/1ada86c0-c991-437b-9b6b-09693eb8bcea)

---

### 3. Top 5 Campaigns – Highest Avg. Clicks per Conversion

_**Insight:**_ Some campaigns showed **exceptional conversion efficiency**. For example, campaign **CMP_MY63GT** recorded only 15 clicks but generated 974 conversions, equating to just 0.02 clicks per conversion. This might reflect referral or influencer effects where one click leads to many purchases.

Source: `analysis_cleaned_table` 

 campaign_id   | total_clicks | total_conversions | avg_clicks_per_conversion |
|----------|--------------|----------------|--------------------------------|
| CMP_MY63GT      | 15         | 974          | 0.02  |
| CMP_HRX2CJ    | 17         | 738          | 0.02  |
| CMP_9HV1Z0   | 19         | 866          | 0.02|
| CMP_A5FCUZ  | 13         | 656          | 0.02   |
| CMP_FAZ4X3 | 19         | 780          | 0.02       |

*Table of the top 5 campaigns with highest average clicks per conversion in analysis_cleaned table.*


---

### 4. ROI & Conversions for Discount Range 10%–14%
_**Insight:**_ Surprisingly, **discount levels do not strongly correlate with ROI or conversions**. Average ROI stays around 2.5 even at steep discounts up to 69%, and conversions hover between 400-500 across discount tiers. This suggests that deeper discounts alone don’t guarantee better campaign results and may risk profitability.


 Discount Level (%) | Average ROI | Avg. Conversions | Max ROI | Max Conversions |
|--------------------|-------------|------------------|---------|------------------|
| 10                 | 2.72        | 533.44           | 4.97    | 993              |
| 11                 | 2.76        | 471.09           | 4.98    | 995              |
| 12                 | 2.74        | 491.13           | 4.99    | 984              |
| 13                 | 2.75        | 509.10           | 4.99    | 998              |
| 14                 | 2.70        | 514.75           | 5.00    | 994              |	
| ...                 | ...        | ...              | ...     | ...              |	
| 69                 | 2.62        | 519.05           | 4.99    | 998              |	

*Table of the average and maximum ROI, Conversions for the discounts 10% to 14%. Note: The summary is based on a broader dataset spanning discount levels from 10% to 69%.*


---

### 5. Categorized Discount Range – Sorted by Avg. ROI & Conversions
_**Insight:**_ Discounts in the **30%-39% range provide the best balance**, yielding the highest average conversions (511) and strong ROI. While the 40%-49% range edges out slightly on ROI, it sees fewer conversions, suggesting that "too high" discounts do not always boost performance.


 discount range | average ROI     | avg_conversions | 
|----------|------------|--------------|
| 10--19%        | 2.71         | 499.04           |      
| 20--29%     | 2.74 | 507.94           |           
| 30--39%       | 2.79     | 510.99           |           
| 40--49%       | 2.80  | 489.84           |           
| 50%+      | 2.75      | 492.78           |           

*Table of categorised discount range sorted by average ROI and Conversions.*


---

### 6. Top Bundle Prices vs Units Sold  
_**Insight:**_ There is **no clear pattern between bundle price and sales volume**. Prices hover around $50, but units sold vary widely, from 14 to nearly 200, implying factors like product appeal, promotion, or bundle content impact sales more than price alone.



*(Rows extend up to 10,000 entries — only top shown)*  
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

---

### 7. Average Customer Satisfaction Scores by Bundle Price Range  

_**Insight:**_ Customer satisfaction scores are **stable across all price levels**, ranging narrowly from 2.47 to 2.54 out of 5. This indicates price is not a major factor in satisfaction; instead, quality, brand experience, or service likely drive how customers feel about their purchases.


 Price Range       | Average Satisfaction |
|-------------------|----------------------|
| $100 – $199       | 2.51                 |
| $200 – $299       | 2.47                 |
| Above $300+       | 2.50                 |
| Below $100        | 2.54                 |

*Table of Average Customer Satisfaction Scores by Bundle Price Range.*

---

### 8. Consumer Keywords Frequency & Average Conversions  
_**Insight:**_ Campaigns emphasizing the keyword **“Innovative”** saw the highest average conversions (507.7), followed by “Durable” and “Stylish.” Interestingly, “Affordable,” the most frequent keyword, had the lowest conversions, reinforcing that **aspirational messaging drives better results than price-focused language**.


| **Keyword**   | **Average Conversions** | **Keyword Count** |
|---------------|--------------------------|--------------------|
| Innovative    | 507.70                   | 2,491              |
| Durable       | 504.60                   | 2,436              |
| Stylish       | 494.33                   | 2,514              |
| Affordable    | 489.71                   | 2,559              |

*Results Table of Consumer Keywords frequency and Average Conversions.*

---

## ⚡ Immediate Insights & Recommended Actions

- 📈 **PROVEN Campaign Winners:**  
  Campaigns like `CMP_2GQ60B`, `CMP_5590UQ`, and `CMP_U44WCH` consistently deliver the highest ROI. These represent repeatable winning strategies that marketing teams should study and replicate to maximize future campaign success.

- 💡 **Revenue Driven by Volume, NOT Price:**  
  Surprisingly, the **Basic subscription tier generates more revenue than Premium**, likely due to a larger or more loyal customer base. This highlights an opportunity to focus on upselling and retention within the Basic tier to boost returns.

- 🎯 **INVESTIGATE Ultra-Effective Campaigns:**  
  Some campaigns, such as `CMP_MY63GT`, achieve exceptional conversion rates—possibly due to referral programs or influencer marketing. Diving deeper into these could uncover powerful tactics to scale across other campaigns.

- 💰 **Discounts DO NOT ALWAYS MEAN Better Results:**  
  Offering bigger discounts doesn’t automatically improve ROI or conversions. Most customers are **price insensitive**, so aggressive discounting can erode profits without boosting sales. Instead, focus on **mid-range discounts (30-39%)** to balance customer attraction with profitability.

- 😊 **Customer Satisfaction IS NOT About Price:**  
  Satisfaction scores remain steady across all price ranges, suggesting that **quality and brand experience matter more** than price in shaping how customers feel.

- ❤️ **Emotional Appeal BEATS Affordability:**  
  While `Affordable` is the most frequently used campaign keyword, it correlates with lower conversions. This shows that **emotional and aspirational messaging drives stronger customer engagement** than price-focused language.

From these insights, we now have a clearer, actionable direction to optimize marketing strategies, pricing, and messaging for stronger business results.

---

## 🛠 Tools & Technologies
- **PostgreSQL** for data querying
- **SQL** for calculations and aggregations
- **Python (optional)** for additional visualizations
- **Excel / CSV** for initial data source

---
