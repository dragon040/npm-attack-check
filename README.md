# npm-attack-check

A shell script that not only detects compromised packages, but also suggests safe versions, and optionally cleans your NPM cache and reinstalls dependencies.

# How to Run

Save the script as npm-security-check.sh.
Run it in your Node.js project directory
bash npm-security-check.sh

# Recommended Actions

Audit your lockfiles (package-lock.json, yarn.lock, pnpm-lock.yaml)
Clear caches: npm cache clean --force
Pin safe versions in package.json
Rebuild affected environments
Monitor runtime behavior for suspicious activity
