---
name: review
description: Review changes against a fixed point, or uncommitted work, with parallel fresh reviewer subagents
disable-model-invocation: true
---

Orchestrate a review of one pinned change scope. Never modify project files yourself.

## Inputs

Both optional:

- **Fixed point**: a Git reference (commit SHA, branch, tag, `main`, `HEAD~5`), resolved once to a commit SHA.
- **Intent**: a spec path, ticket URL, or task description stating what the change is meant to do. If none is supplied, look for a relevant `plan.md` in the artifacts directory; if several are plausible, ask the user.

## Pin the scope

Do this before launching any reviewer, and stop with a report on any error or empty scope; never defer these to reviewers.

- **With a fixed point**: resolve it and `HEAD` to commit SHAs with `git rev-parse --verify <ref>^{commit}`. Record their merge-base SHA. The scope is `git diff <merge-base-sha> <head-sha>` and the commit list is `git log <fixed-point-sha>..<head-sha> --oneline`. Review the committed contents at these SHAs, not unrelated working-tree changes.
- **Without one**: if `git status --porcelain --untracked-files=all` is non-empty, select uncommitted work. Resolve `HEAD` to a commit SHA; the scope is `git diff <head-sha>` plus the untracked files from `git ls-files --others --exclude-standard`, treated as additions. Otherwise select `main` as the fixed point.

Retain the selected scope type and SHAs throughout the review. After the hook, refresh the diff and untracked file list for uncommitted work; stop if the scope is now empty or `HEAD` changed. Never rerun automatic scope selection. During parallel review, do not launch writers; if external edits change the reviewed contents, invalidate the affected results and refresh before reviewing again.

## Run reviewers

Launch each reviewer as a fresh `reviewer` subagent. Give each subagent its own instruction file below to read and follow:

1. [precommit-reviewer.md](./precommit-reviewer.md) — run it alone first. Only the hook may modify project files; the reviewer must not edit them directly. Then refresh the scope as described above.
2. Launch one subagent per file in a single parallel run:
   - [correctness-reviewer.md](./correctness-reviewer.md)
   - [design-reviewer.md](./design-reviewer.md)
   - [conventions-reviewer.md](./conventions-reviewer.md)
   - [intention-reviewer.md](./intention-reviewer.md), only when an intent is available

Give every reviewer the pinned scope commands, the untracked file list or commit list, and the intent if any. Pass the hook's validation results and coverage to the parallel reviewers. Tell each to inspect the repository at the pinned scope and follow these shared rules:

- Review only the selected changes; inspect surrounding code as needed to establish their effects.
- Do not modify project files, except through the hook in step 1.
- Return an explicit completion status and evidence-backed findings, each citing `path:line` and suggesting a specific change. Validation failures may cite the command and output when no source location applies. Keep each report under 400 words.
- Skip a tooling-enforced check only when it is confirmed to have passed for the reviewed contents and scope.

Wait for every reviewer to finish. A reviewer that failed, or was skipped, is reported as such, never as having no findings.

## Synthesize

Deduplicate overlapping findings, reject scope expansion, and classify each as:

- **fix now**: supported by evidence, worth addressing, and within the approved scope without requiring a new user decision.
- **needs user decision**: requires a product, API, architecture, or scope choice beyond existing approval.
- **optional or deferred**: valid but nonessential or postponed under the calling workflow's rules; state why.
- **rejected**: unsupported, inapplicable, or scope expansion; state why.

Present findings grouped by disposition, retaining reviewer attribution after deduplication. Include reviewer statuses and validation coverage separately. When this skill is followed as part of another workflow, return the classified findings to it instead of acting on them.
