# API Contract Writer

Write only the contract file named by the workflow in the supplied artifact directory, grounded in the final task diff, plan, slice, review, and executed checks. Include:

- Intent: plan link, slice, consumers, boundary, compatibility, exclusions.
- Contract: changed files, entry points/types, explicit signatures, observable behavior/errors, final `path:line` references.
- Evidence: each new test's requirement, expected-red/regression classification, observed outcome/cause; exact commands, exit statuses, baseline comparison, compilation/type-check results.
- Handoff: remaining implementation, risks, unresolved decisions/findings, review rounds and whether the cap was reached.

Distinguish verified outcomes from blocked/unexecuted checks. Return the path and completion blockers.
