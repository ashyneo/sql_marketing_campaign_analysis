-- We have imported the csv file. Let's create the Table.
CREATE TABLE mktg_analysis (
    campaign_id TEXT,
    product_id TEXT,
    budget FLOAT,
    clicks INTEGER,
    conversions INTEGER,
    revenue_generated FLOAT,
    return_on_investments FLOAT,
    customer_id TEXT,
    subscription_tier TEXT,
    subscription_length INTEGER,
    flash_sale_id TEXT,
    discount_level INTEGER,
    units_sold INTEGER,
    bundle_id TEXT,
    bundle_price FLOAT,
    customer_satisfaction INTEGER,
    common_keywords TEXT
);


-- Set ownership of the tables to the postgres user (myself)
ALTER TABLE mktg_analysis OWNER to postgres;

--LOADING THE TABLE:

-- Since there was permission denied intiailly, I had to copy my csv file to the tmp directory on macOS using terminal.
COPY mktg_analysis
FROM '/tmp/marketing_and_product_performance.csv'
DELIMITER ',' CSV HEADER
NULL 'NULL';


-- Test the code to see if the table is successfully imported:
SELECT *
FROM mktg_analysis   -- File successfully loaded into TABLE!

