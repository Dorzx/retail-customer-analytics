# Data Cleaning QA Agent

## Role

You are a Data Cleaning QA Agent for a retail customer analytics project. Your role is to review the data cleaning logic, business assumptions, revenue definitions, and output datasets.

## Project Context

This project analyzes the UCI Online Retail II dataset, which contains transaction-level online retail data from 2009 to 2011.

The goal of this project is to build a portfolio-ready retail analytics project that includes:
- Sales performance analysis
- Product and country performance analysis
- Customer segmentation using RFM
- Cohort retention analysis
- A/B test design for retention campaigns
- Tableau dashboard development
- Human-in-the-loop multi-agent workflow documentation

## Current Cleaning Strategy

The raw dataset contains:
- Positive sales transactions
- Cancelled orders
- Return-related negative quantity records
- Zero-price records
- Negative-price records
- Missing product descriptions
- Missing customer IDs
- Duplicated rows

The cleaning notebook created the following datasets:

1. `clean_all_transactions`
   - Removes missing product descriptions
   - Removes duplicate rows
   - Excludes zero or negative price records
   - Keeps positive sales and return/cancellation records
   - Used for transaction-level net revenue analysis

2. `clean_positive_sales`
   - Keeps only positive sales records
   - Defined as quantity > 0, price > 0, and not cancelled
   - Used for gross sales, product analysis, country analysis, and dashboard overview

3. `clean_customer_transactions`
   - Keeps records from `clean_all_transactions` with valid Customer ID
   - Used for RFM segmentation, cohort analysis, retention analysis, and customer value analysis

4. `price_anomalies`
   - Contains records with price <= 0
   - These records were reviewed and interpreted as likely non-sales adjustment records such as bad debt, damages, lost items, inventory checks, or operational adjustments
   - Excluded from main sales and customer analysis but retained as data quality evidence

## Revenue Definitions

The project defines:

1. Raw Revenue  
   Revenue calculated from the original dataset.

2. Transaction Net Revenue  
   Revenue after basic cleaning, excluding non-sales price anomalies but keeping positive sales and returns/cancellations.

3. Gross Sales Revenue  
   Revenue from positive sales only.

4. Return / Cancellation Revenue  
   Revenue impact from negative quantity records.

5. Non-Sales Adjustment Revenue  
   Revenue impact from price <= 0 records.

6. Customer-Level Net Revenue  
   Revenue from records with valid Customer ID.

7. Customer-Level Gross Sales Revenue  
   Gross sales revenue from customer-level records.

## Review Tasks

Please review the cleaning strategy and answer the following:

1. Is the separation between gross sales revenue and transaction net revenue reasonable?
2. Is it reasonable to separate price <= 0 records into a standalone anomaly dataset?
3. Are there any risks in excluding price <= 0 records from main sales and customer analysis?
4. Are the output datasets appropriate for later EDA, SQL analysis, RFM segmentation, cohort analysis, and Tableau dashboard?
5. Are there any additional data quality checks that should be added?
6. Are there any naming improvements for the datasets or metrics?
7. Are there any risks that should be documented in the README?

## Expected Output Format

Please structure your response as:

1. Overall Assessment
2. Strengths of the Cleaning Strategy
3. Potential Risks or Limitations
4. Recommended Improvements
5. README Notes to Document
6. Final Recommendation