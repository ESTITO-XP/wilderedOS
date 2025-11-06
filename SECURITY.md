# 🛡️ WilderedOS Security

<div align="center">
<img width="1920" height="1080" alt="jw" src="https://github.com/user-attachments/assets/e11e904a-8b64-4aee-bc32-d8be635a07b5" />
  
**___We value your safety, and provide a better experience with WilderedOS___**
</div>

---

## Table of contents
- [Reporting a Vulnerability](#reporting-a-vulnerability)
- [What to include in a report](#what-to-include-in-a-report)
- [Response and timeline](#response-and-timeline)
- [Supported versions](#supported-versions)
- [Severity classification](#severity-classification)
- [Responsible disclosure policy](#responsible-disclosure-policy)
- [Safe harbor](#safe-harbor)
- [Acknowledgements](#acknowledgements)

---

## Reporting a Vulnerability
If you believe you've found a security vulnerability in WilderedOS, please report it to us privately. Preferred channels:
- Email: security@wilderedos.example (PGP available — see below)
- Secure upload form: https://wilderedos.example/security-report
If you do not get a response in 72 hours, please resend with "URGENT" in the subject.

### PGP key
We publish our PGP key at: https://wilderedos.example/pgp.txt  
(Include a fingerpint here or attach your key when reporting sensitive data.)

---

## What to include in a report
Helpful information accelerates our response:
- A clear summary of the issue
- Steps to reproduce (minimum reproducible example)
- Affected versions and components
- Proof-of-concept code or exploit (preferably in a safe, non-malicious form)
- Any mitigations or workarounds you used

Do NOT include sensitive user data or full exploits in public threads—send them over the private channel above.

---

## Response and timeline
Our typical process:
1. Acknowledgement: within 48–72 hours.
2. Triage: determine impact and reproduce.
3. Fix & patch: prioritize according to severity.
4. Public disclosure and CVE assignment: coordinated with reporter.

If you provided a PGP-encrypted report, we will respond via encrypted email.

---

## Supported versions
We only support and issue security fixes for the currently maintained releases. If you are running an EOL release, it may not receive patches.

---

## Severity classification
We use a simple scale to prioritize fixes:
- Critical: remote code execution, complete data compromise
- High: privilege escalation, serious data leak
- Medium: useful but requires local access or user interaction
- Low: minor issues, validation or info messages

We will always prioritize critical issues for immediate fixes.

---

## Responsible disclosure policy
- Please report issues privately to our security channel.
- Avoid public disclosure until we have had a reasonable time to respond and release a fix (usually up to 90 days depending on complexity).
- We will credit reporters who follow this policy unless you request anonymity.

---

## Safe harbor
If you follow this policy in good faith and avoid causing harm, we will not pursue legal action against you for testing on your own accounts or infrastructure or for reporting issues responsibly.

---

## Acknowledgements
We appreciate researchers and community members who help keep WilderedOS secure. If you would like to be credited, mention how you want your name displayed when you submit a report.

---
