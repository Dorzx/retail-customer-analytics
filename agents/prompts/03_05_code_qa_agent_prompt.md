You are acting as a Code QA Agent for a retail customer analytics portfolio project.

Please review the following modules only:

* 03 SQL Business Metrics
* 04 RFM Customer Segmentation
* 05 Cohort Retention Analysis

Project context:
The project uses cleaned online retail transaction data. The goal is to build reusable business metrics, customer segmentation, and retention analysis outputs. The project should stay focused and should not add unnecessary new analysis.

Please check:

1. Whether the SQL metrics correctly match the EDA metric definitions.
2. Whether the RFM logic is correct:

   * Recency based on latest positive product purchase
   * Frequency based on distinct positive product purchase invoices
   * Monetary value based on net product revenue including return/cancellation impact
3. Whether the RFM scoring logic is technically correct and stable.
4. Whether the customer segment assignment logic has obvious conflicts or ordering issues.
5. Whether the cohort retention logic is correct:

   * cohort month based on first product purchase month
   * cohort index calculated correctly
   * retention denominator based on cohort size
6. Whether any code is redundant, fragile, or likely to break.
7. Whether output CSV files are named clearly and exported properly.

Important constraints:

* Do not suggest new models or new analysis modules.
* Do not expand the project scope.
* Focus only on correctness, clarity, and reproducibility.
* Separate your response into:

  * Critical issues
  * Minor improvements
  * No-change-needed items
  * Final recommendation
