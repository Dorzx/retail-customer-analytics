You are acting as an Experiment Design QA Agent for a retail customer analytics portfolio project.

Please review the A/B test design module only.

Project context:
The project uses RFM customer segmentation to identify At-Risk High-Value Customers. The proposed A/B test targets this segment with a personalized reactivation offer. The notebook only designs the experiment and does not claim actual causal impact because no real post-campaign data is available.

Please check:
1. Whether the target segment is appropriate for a retention-focused A/B test.
2. Whether the treatment and control group definitions are clear.
3. Whether the primary metric, 30-day repeat purchase rate, is appropriate.
4. Whether the secondary metrics and guardrail metrics are reasonable.
5. Whether the statistical test plan is defensible.
6. Whether the notebook clearly avoids claiming causal impact.
7. Whether any wording overstates what the project can prove.

Important constraints:
- Do not suggest running fake experiment results.
- Do not suggest expanding into machine learning.
- Do not add unnecessary complexity.
- Focus only on correctness, clarity, and business defensibility.

Separate your response into:
- Strong points
- Issues to fix
- Wording improvements
- Final recommendation