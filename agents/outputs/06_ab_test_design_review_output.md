I reviewed all 18 cells including the executed outputs. There's one important discrepancy I need to flag upfront before the structured assessment.

---

## ⚠️ Cross-Notebook Consistency Issue (Review This First)

The segment names and customer counts visible in notebook 06's **executed output** do not match what notebook 04 defines in its code. Specifically:

| Notebook 04 (code defines) | Notebook 06 (CSV output shows) |
|---|---|
| Potential Loyalists (582 customers) | Valuable Regular Customers (570 customers) |
| At-Risk Big Spenders (58 customers) | At-Risk High-Spending Customers (69 customers) |
| Low-value Inactive Customers | Low-Value Inactive Customers |

This means the `rfm_customer_segments.csv` being read in notebook 06 was produced by a **different, more recent version** of notebook 04 than the one submitted for review. The portfolio is currently inconsistent — if someone re-runs notebook 04 as written, they will produce different segment names and counts than what notebook 06 reads. This must be resolved before submission: either update notebook 04 to match its own output, or confirm which version is canonical and re-export. The rest of this review treats the notebook 06 segment names and counts as the live version.

---

## Strong Points

The target segment selection is well-reasoned. At-Risk High-Value Customers have avg recency of 341 days, avg frequency of 9.6 orders, and avg monetary value of ~$4,079 — genuinely high historical engagement that has gone dormant. This combination makes the business case for a reactivation campaign intuitive and defensible: the customers demonstrably know the brand, and their lapsed status is clear without being ambiguous.

The causal disclaimer is handled well and is repeated in the right places — it appears in the Business Problem cell, the Random Assignment Check cell, the Success Metric Framework cell, and the Summary cell. A reviewer can't miss it. This is the single most important thing to get right in a portfolio A/B design notebook that lacks real outcome data, and it's done correctly throughout.

The pre-test group imbalance is proactively acknowledged in Cell 10. The treatment group ($3,797 avg monetary value) and control group ($4,375 avg monetary value) differ by about 13% due to the small population size. The notebook correctly notes this, and the suggested remedies — stratified random assignment or pre-period covariate control — are exactly what a practitioner would recommend.

The revenue skew caveat in the statistical test plan is appropriate and shows good statistical instincts: "Revenue metrics may be skewed by a small number of high-value customers, so they should support but not replace the primary metric." This is exactly the right framing for retail revenue data.

The guardrail metrics `project_note` column — distinguishing metrics that *could* be measured from those that are *not available in this dataset* — is a clean, honest way to demonstrate understanding of what a full experiment requires without pretending to have data you don't.

---

## Issues to Fix

**The secondary metrics and guardrail metrics tables are heavily redundant.** Three of five guardrail metrics — return/cancellation rate, revenue per customer, and average order value — also appear in the secondary metrics table. In standard experiment frameworks these two categories are conceptually distinct: secondary metrics are outcomes you want to *move*, while guardrail metrics are constraints you don't want to *break*. Listing the same metrics in both tables muddies this distinction and will read as confusion to a technical reviewer. The fix is to make the distinction explicit: keep return/cancellation rate as a guardrail only (you don't want to *improve* it, you want it to stay stable), and decide whether revenue per customer and average order value belong in secondary metrics, guardrail metrics, or both — with a clear stated reason for any overlap.

**The alternative hypothesis implies a one-sided test but the stated test method doesn't commit to this.** The statistical test plan states: "Treatment group has a higher 30-day repeat purchase rate than control group" — this is directional and implies a one-sided test. But listing "chi-square test" as an option is inconsistent because chi-square is inherently two-sided. Either commit to a one-sided z-test and explain why (the campaign is only rolled out if it helps, so a one-sided test is justified), or use a two-sided test and update the alternative hypothesis to "the two groups have different repeat purchase rates." For a conservative portfolio design, two-sided is the more defensible default.

**Campaign conversion rate is miscategorized as a secondary metric.** "Share of treatment customers who use the campaign offer" is a treatment-arm-only operational metric — there is no control group analogue to compare against. It can't be compared between groups the way a true secondary metric can. It belongs in a separate "campaign delivery metrics" or "implementation checks" category, or should come with a note that it measures uptake within the treatment arm only rather than treatment vs. control contrast.

**The sample size underpowering caveat is present but unquantified.** The summary correctly states the experiment "may have limited statistical power." However, 207 customers split 50/50 is genuinely problematic for most realistic effect sizes — not just potentially limited. At-risk customers who've been inactive for nearly a year would realistically have a low baseline repeat purchase rate (likely under 15%), and a meaningful campaign lift might be 5–8 percentage points. At that effect size and sample size, statistical power would fall well below the stated 80% target. The current wording ("may have limited statistical power") undersells a real constraint. Strengthening this to acknowledge that 207 total customers is likely insufficient to reach the 80% power target without a larger-than-typical effect size would make the notebook more analytically honest without adding new scope.

**"Practically higher" in the success definition is undefined.** The success definition reads: "Treatment group has a statistically and practically higher repeat purchase rate than control group." Mentioning practical significance is good instinct, but without any anchor — even a general one like "a lift large enough to recover campaign cost" — this phrase reads as filler. Either define a minimum meaningful lift or rephrase to remove the ambiguity.

---

## Wording Improvements

The opening scope bullet "Create random assignment plan" slightly overstates what the notebook does. The assignment uses `np.random.choice` on historical RFM data — it's a simulated randomization to show the structure, not an operational deployment plan. "Demonstrate random assignment structure" or "Illustrate group assignment methodology" would be more accurate without underselling the work.

In Cell 10, "the business team could use stratified random assignment" would benefit from a one-line clarification of *what to stratify on* — e.g., stratify on recency decile or monetary value quartile — to show the recommendation is concrete rather than generic.

The experiment window is defined as "30 days after campaign launch," which is clear. However, given that At-Risk High-Value Customers have average recency of 341 days (~11 months inactive), adding a one-sentence acknowledgment that a 30-day window is a standard reactivation benchmark — and that a longer window could be appropriate for deeply lapsed customers — would demonstrate awareness of this design tradeoff without requiring any change to the design itself.

In the statistical test plan, "if sample size planning is available" as a qualifier for the 80% power target reads awkwardly. Sample size planning is not a resource you acquire; it's a calculation you perform. Rephrase to "if a baseline repeat purchase rate can be estimated prior to launch" or simply "subject to sample size calculation before launch."

---

## Final Recommendation

This notebook succeeds at its core purpose: demonstrating that a candidate understands how to *frame* an A/B experiment — target selection rationale, group structure, metric hierarchy, and statistical approach — without fabricating results they don't have. For a portfolio piece, that framing competence is exactly what a hiring manager is assessing, and it shows here.

The cross-notebook segment name discrepancy is the most urgent fix and must be resolved before submission — it's a reproducibility failure that a technical reviewer would catch immediately. After that, the secondary/guardrail metric overlap and the one-sided/two-sided test inconsistency are the two issues most likely to draw skepticism from a statistically literate audience. The sample size honesty improvement is worth making because quantified humility is more impressive than vague caveats. The remaining wording changes are lower priority but add polish. Fix the critical items and this notebook is in strong shape for its intended purpose.