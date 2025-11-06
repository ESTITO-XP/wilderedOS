# Contributing to WilderedOS

<img width="1920" height="1080" alt="jx" src="https://github.com/user-attachments/assets/2990d1b7-9581-4f70-a681-3d75c654a6fb" />


Thank you for your interest in contributing to WilderedOS! We welcome contributions from everyone — from bug reports and documentation fixes to feature proposals and code changes. This guide explains how to get started and what we expect from contributors.

---

## Table of contents
- [Code of Conduct](#code-of-conduct)
- [Getting started](#getting-started)
- [Reporting issues](#reporting-issues)
- [Feature requests](#feature-requests)
- [Development workflow](#development-workflow)
- [Branching model](#branching-model)
- [Commit messages](#commit-messages)
- [Pull request process](#pull-request-process)
- [Testing and CI](#testing-and-ci)
- [Code style and linting](#code-style-and-linting)
- [Documentation](#documentation)
- [Security](#security)
- [Licensing and DCO/CLA](#licensing-and-dcocla)
- [Acknowledgements](#acknowledgements)

---

## Code of Conduct
Please follow our Code of Conduct in all interactions with the project. Respectful communication and constructive feedback are required. Check it out [here](CODE_OF_CONDUCT.md) for details.

---

## Getting started
1. Fork the repository and clone your fork:
   ```bash
   git clone git@github.com:your-username/WilderedOS.git
   cd WilderedOS
   ```
2. Install dependencies (language/tooling-specific — see README for setup):
   ```bash
   # example for Node-based projects
   npm install
   # or for Python
   pip install -r requirements.txt
   ```
3. Run the test suite locally:
   ```bash
   npm test
   # or
   pytest
   ```

---

## Reporting issues
Before opening an issue:
- Search existing issues to avoid duplicates.
- Try to provide a minimal, reproducible example.

When creating an issue, include:
- A descriptive title.
- Steps to reproduce.
- Expected and actual behavior.
- Version(s) of WilderedOS and environment information.
- Logs, stack traces, and screenshots where appropriate.

For security vulnerabilities, do not open a public issue — see the Security section below.

---

## Feature requests
Feature requests should be opened as issues with the `enhancement` label. Include:
- The problem you're solving.
- Proposed API or UX changes.
- Backwards-compatibility considerations.
- Any alternatives you considered.

We prefer scoped, small, and well-explained feature proposals.

---

## Development workflow
1. Create a branch from the main development branch (see Branching model).
2. Make small, focused changes. One PR should solve one problem or implement one small feature.
3. Write or update tests for your changes.
4. Ensure all CI checks pass locally before pushing.
5. Open a Pull Request (PR) describing the change and linking related issues.

---

## Branching model
- main (or trunk): stable, production-ready code.
- develop (optional): integration branch for ongoing development.
- feature/*: for new features (e.g., feature/add-foo)
- fix/* or bugfix/*: for bug fixes
- chore/*: for maintenance tasks

Branch names should be descriptive and lower-case with dashes.

---

## Commit messages
We follow a conventional commit style to keep history readable and machine-parseable.

Format:
```
<type>(scope?): <short summary>

<body> (optional)

<footer> (optional)
```

Common types:
- feat: a new feature
- fix: a bug fix
- docs: documentation only changes
- style: formatting, missing semicolons, etc.
- refactor: code change that neither fixes a bug nor adds a feature
- test: adding or updating tests
- chore: build process or auxiliary tools

Example:
```
feat(network): add retry logic for API requests

Adds configurable exponential backoff and retries to network requests.
```

Sign commits if required by project policy:
```bash
git commit -s -m "feat: something"
# or with GPG signing
git commit -S -m "fix: something"
```

---

## Pull request process
- Target the appropriate branch (see Branching model).
- Include a clear title and description.
- Link related issues (e.g., "Closes #123").
- Describe the testing you performed.
- Keep changes small; large changes may be split into multiple PRs.
- Add relevant labels if you have permission.

Pull request checklist (we will check these during review):
- [ ] I have read the contribution guide.
- [ ] I added/updated tests.
- [ ] I updated documentation where necessary.
- [ ] My changes pass existing CI and linters.
- [ ] I added migration notes if the change affects end users.

---

## Testing and CI
- All changes must include tests where applicable.
- Run the full test suite locally before opening a PR.
- CI is configured to run tests, linters, and build checks on each PR — ensure your branch passes CI.
- If a test is flaky, add a comment in the PR explaining why and open an issue to address flakiness.

---

## Code style and linting
- Follow the project's style guides (see .editorconfig, linter configurations).
- Run linters and auto-formatters before committing:
  ```bash
  # example
  npm run lint
  npm run format
  ```
- Keep changes focused on logic; avoid unrelated whitespace or style-only changes mixed with functional changes.

---

## Documentation
- Update docs when adding or changing public APIs or user-facing behavior.
- Keep docs in sync with code — broken or out-of-date docs create friction for users.
- For major changes, consider adding migration notes in CHANGELOG.md.

---

## Security
For security issues, please see SECURITY.md and report vulnerabilities privately according to the instructions there. Do not post security-sensitive information in public issues or PR comments.

---

## Licensing, DCO, and CLA
- Contributions inherit the project's license. By submitting a PR you agree to license your contributions under the project's license.
- If required by the project, sign the Developer Certificate of Origin (DCO):
  ```bash
  git commit -s -m "..."
  ```
- If this project uses a CLA, you will be asked to sign it before your first contribution is merged.

---

## Acknowledgements
Thanks for helping improve WilderedOS. We appreciate your time and effort. Contributors who follow this guide will get faster reviews and smoother merges.

If you have any questions, open an issue or contact the maintainers.

---
