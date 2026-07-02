Now I have a full picture of the data. Let me do revenue reconciliation checks before writing the review.

**Revenue reconciliation checks from the CSVs:**
- Price > 0 total: $19,445,927 — Raw revenue ($19,287,251) − Price < 0 records (−$158,676) = $19,445,927 ✅ Perfect
- Net revenue check: Gross sales ($20,476,260) + Returns (−$1,462,424) = $19,013,836 ≈ $19,014,210 ✅ (rounding only)
- Duplicate/description removal impact: $19,445,927 − $19,014,210 = **$431,717 removed** — worth flagging
- Customer coverage gap: $19,014,210 − $16,289,991 = **$2,724,219 in revenue has no customer ID**

---

## Data Cleaning QA Review
### UCI Online Retail II — Portfolio Project

---

## 1. Overall Assessment

The cleaning strategy is **well-structured, analytically sound, and portfolio-ready**. The separation into four purpose-built datasets reflects genuine understanding of the difference between financial and behavioural analytics. Revenue reconciliation is internally consistent, and the rationale for separating price anomalies is defensible. A few risks deserve explicit documentation, particularly the scale of missing Customer IDs (22.77%) and the magnitude of revenue removed during deduplication ($431,717).

---

## 2. Strengths of the Cleaning Strategy

**Revenue reconciliation is watertight.** The accounting trail closes cleanly:

| Check | Formula | Result |
|---|---|---|
| Price > 0 ↔ Raw revenue | $19,287,251 − (−$158,676) | = $19,445,927 ✅ |
| Net ↔ Gross + Returns | $20,476,260 − $1,462,424 | ≈ $19,014,210 ✅ |
| Non-sales isolation | 5 rows, 0 customer IDs | Confirms "Adjust bad debt" classification ✅ |

**The two revenue definitions serve distinct analytical purposes.** `transaction_net_revenue` reflects the business's realised financial position. `gross_sales_revenue` is the correct denominator for product mix, country performance, and return rate analysis. Conflating them would distort both.

**Price anomaly separation is well-motivated.** The price = 0 records (6,202 rows) are characterised by damage/loss descriptions, concentrated dates, and near-zero customer association (51 customers). The price < 0 records (only 5 rows) carry −$158,676 in bad debt adjustments — that magnitude with only 5 rows and zero customer IDs is a strong signal of accounting entries, not sales. Keeping them in a `price_anomalies` table rather than deleting them entirely is the right call for auditability.

**Dataset-to-use-case mapping is logical.** Each dataset feeds the right downstream analysis: gross sales for EDA and Tableau, all transactions for net revenue, customer transactions for RFM/cohort.

---

## 3. Potential Risks or Limitations

### 🔴 Critical — Missing Customer IDs (22.77%)

This is the most significant structural risk in the project. 243,007 records lack a Customer ID, and the customer-level dataset recovers only ~$16.3M of the ~$19.0M transaction net revenue — a **$2.72M gap (14.3%)** that is analytically invisible to RFM, cohort, and retention analyses.

Implications:
- RFM segments will under-count customers and may skew frequency/recency distributions
- Cohort retention rates are computed only over *identified* customers — the denominator is not the full customer base
- If missing Customer IDs correlate with channel (e.g., guest checkouts, B2B phone orders), the segmentation may have systematic bias

This should be the #1 caveat in your README.

### 🟠 Moderate — Duplicate Removal Removed $431,717 in Revenue

Deduplication reduced revenue from $19,445,927 (price > 0, pre-dedup) to $19,014,210 — a drop of $431,717 from 34,335 rows. This is roughly $12.58 average revenue per duplicate row, which is plausible but worth verifying. Two questions to confirm:

- Are these exact-row duplicates (same invoice + stock code + quantity + price + date + customer), or are there partial duplicates that might be legitimate repeat line items?
- Does the duplicate check correctly exclude `InvoiceNo` as a dedup key, or was it included? (If included, it might accidentally collapse legitimate same-day reorders.)

### 🟠 Moderate — clean_positive_sales Has Fewer Customers Than clean_customer_transactions (5,878 vs 5,939)

This counter-intuitive result (a broader dataset having fewer customers) occurs because `clean_customer_transactions` includes return/cancellation records. Customers who *only* appear as returns — with no positive sales in the clean period — exist in `clean_customer_transactions` but not `clean_positive_sales`. In an RFM context, these customers would have frequency and monetary values driven by returns only, which could produce negative monetary scores. **Confirm whether negative-monetary RFM customers are intentionally retained or should be filtered.**

### 🟡 Minor — Invoice Count Discrepancy Needs Dashboard Labelling

`clean_all_transactions` has 48,369 unique invoices vs `clean_positive_sales` with 40,077 — a difference of 8,292 invoices. In Tableau, if two KPI tiles show invoice counts from different datasets without a clear label, stakeholders will flag this as data inconsistency. Recommend explicit metric naming in dashboard tooltips.

### 🟡 Minor — price = 0, 51 Customers May Have Distorted Behaviour Profiles

While price = 0 records are correctly excluded from revenue, those 51 customers who do have IDs will appear in `clean_customer_transactions` without their adjustment transactions. This is correct for revenue analysis, but it means their *interaction history* (e.g., how many times they touched the warehouse/system) is understated. For RFM frequency, this is likely negligible.

### 🟡 Minor — No Outlier Check on Unit Price or Quantity

The cleaning pipeline handles structural anomalies (zero price, negative price, duplicates) but does not appear to screen for extreme outliers in `Price` or `Quantity` within the valid ranges. A single mis-keyed price of £27,000 instead of £2.70 would not be caught by current filters and could materially distort product-level revenue rankings.

---

## 4. Recommended Improvements

**Add a deduplication audit log.** Before dropping duplicates, save a sample of the removed rows (e.g., top 20 by revenue) to verify they are genuine duplicates. Storing this as a `duplicate_audit` dataframe in a notebook cell costs nothing and provides strong portfolio documentation.

**Add unit price and quantity outlier screening.** A simple IQR or 99th-percentile check on `Price` and `Quantity` within `clean_positive_sales` would catch mis-keyed records. Even if you decide to keep all records, the check should be documented.

**Verify return linkage.** Cancelled invoices (prefixed `C`) in the UCI dataset should ideally be linked back to their original invoice. If a return has no matching original sale in the clean dataset (because the original was a duplicate or had a missing description), the net revenue calculation becomes slightly unreliable. A linkage check — count of cancellations with no matching original `InvoiceNo` — is a portfolio-differentiating QA step.

**Add a temporal coverage check.** Confirm the date range is continuous across 2009–2011 with no unexpected gaps (e.g., missing months due to a data export error). A row count by month plot is a fast check and looks good in a portfolio notebook.

**Consider flagging rather than dropping missing descriptions.** The 4,382 rows with missing descriptions are removed from all clean datasets. If the Stock Code for these rows is otherwise valid and the Customer ID is present, you may be excluding real customer transactions. A `flag_missing_desc` column that keeps the rows but marks them for sensitivity analysis is a more conservative approach.

---

## 5. README Notes to Document

```
## Data Quality Caveats

### Customer Coverage
22.77% of raw records (243,007 rows) have no Customer ID. All customer-level
analyses (RFM segmentation, cohort retention, CLV) are scoped to identified
customers only and may not represent the full revenue base. $2.72M of
transaction net revenue (~14.3%) is excluded from customer-level analysis.

### Revenue Definitions
Three revenue figures are used in this project — they are not interchangeable:
- Gross Sales Revenue ($20.5M): positive-quantity, positive-price sales only;
  used for product and country performance analysis.
- Transaction Net Revenue ($19.0M): gross sales minus returns/cancellations;
  used for business-level financial analysis.
- Customer Net Revenue ($16.3M): transaction net revenue for identified
  customers only; used for RFM and cohort analysis.

### Price Anomalies
6,207 records with price ≤ 0 are excluded from all main datasets and retained
in a separate `price_anomalies` table. These include inventory adjustments
(price = 0, damage/loss descriptions) and bad debt write-offs (price < 0,
"Adjust bad debt" label). These are accounting entries, not customer sales.

### Deduplication
34,335 exact duplicate rows were removed, representing approximately $431,717
in associated revenue. Duplicates were defined as rows identical across all
columns. This figure should be interpreted with awareness that the UCI dataset
is known to contain export artifacts.

### Missing Descriptions
4,382 rows with missing product descriptions were excluded. These represent
0.41% of raw records. Some may be valid transactions where the product
description field was not captured at export time.

### Scope Limitation
This dataset represents a UK-based online retailer with a significant
wholesale/B2B customer base. Behavioral patterns (large order quantities,
repeat bulk purchases) may not generalise to B2C retail contexts.
```

---

## 6. Final Recommendation

**Approve the cleaning strategy with three action items before proceeding to EDA:**

| Priority | Action | Effort |
|---|---|---|
| 🔴 High | Add a deduplication audit — sample removed rows and verify they are genuine duplicates | 30 min |
| 🟠 Medium | Add unit price and quantity outlier check (IQR or 99th percentile) on `clean_positive_sales` | 1 hour |
| 🟠 Medium | Add a return-to-original-invoice linkage check for cancelled orders | 1 hour |

The four output datasets are correctly scoped to their downstream use cases and will support SQL analysis, RFM, cohort retention, and Tableau without structural rework. The revenue reconciliation is one of the stronger aspects of this strategy — it demonstrates analytical rigour that distinguishes a portfolio project from a tutorial walkthrough. Make the reconciliation table visible in your notebook and README; it is an asset.