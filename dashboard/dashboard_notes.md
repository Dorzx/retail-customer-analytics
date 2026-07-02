# Tableau Dashboard Notes

## Dashboard Goal

This dashboard summarizes sales performance, customer value, retention behavior, and experiment opportunities for an online retail business.

The dashboard is based on cleaned and aggregated outputs from the Python and SQL analysis notebooks.

## Main Data Sources

- `kpi_overview.csv`
- `monthly_sales.csv`
- `country_performance.csv`
- `product_performance.csv`
- `return_cancellation_summary.csv`
- `rfm_segment_summary.csv`
- `cohort_summary.csv`
- `ab_test_design.csv`

## Dashboard Structure

### 1. Executive Overview

Purpose: Provide a high-level business performance snapshot.

Recommended views:
- KPI cards:
  - Product Sales Revenue
  - Product Orders
  - Customers
  - Average Order Value
  - Product Return/Cancellation Rate
- Monthly product sales revenue trend

### 2. Country and Product Performance

Purpose: Identify major revenue markets and top-selling products.

Recommended views:
- Revenue by country
- Top products by product sales revenue
- Top products by quantity sold

### 3. Customer Segmentation

Purpose: Show customer value concentration and retention opportunities.

Recommended views:
- Customer count by RFM segment
- Monetary value by RFM segment
- Customer share vs monetary share by segment

### 4. Retention and Experiment Opportunity

Purpose: Connect cohort retention and A/B test design to business action.

Recommended views:
- Cohort summary table
- Target segment summary for A/B test
- A/B test design table

## Important Notes

- Product sales revenue excludes non-product transactions such as manual adjustments, postage, Amazon fees, and bad debt adjustments.
- RFM scores are relative to the current dataset, not fixed business thresholds.
- Cohort retention is monthly repeat-purchase activity, not cumulative retention.
- The A/B test section is a design proposal only and does not claim actual treatment impact.