#!/usr/bin/env bash
# Exports sample portfolio records as a data tree (no personal phone/email).
# Usage: ./scripts/export-data.sh [org-alias]
set -euo pipefail

ORG_ALIAS="${1:-portfolio-app}"
mkdir -p data

echo ">> Exporting sample data from org '$ORG_ALIAS'..."
sf data export tree \
  --query "SELECT Name, Title__c, Headline__c, Bio__c, Location__c FROM About_Me__c" \
  --output-dir data \
  --target-org "$ORG_ALIAS"

sf data export tree \
  --query "SELECT Name, Company__c, Role__c, Start_Date__c, End_Date__c, Is_Current__c, Description__c, Location__c FROM Experience__c" \
  --output-dir data \
  --target-org "$ORG_ALIAS"

sf data export tree \
  --query "SELECT Name, Status__c, Date_Earned__c, Credential_ID__c, Credential_URL__c, Issuing_Organization__c FROM Certification__c" \
  --output-dir data \
  --target-org "$ORG_ALIAS"

sf data export tree \
  --query "SELECT Name, Category__c, Level__c FROM Skill__c" \
  --output-dir data \
  --target-org "$ORG_ALIAS"

sf data export tree \
  --query "SELECT Name, Email__c, Phone__c, LinkedIn__c, GitHub__c, Trailhead__c, City__c FROM Contact_Info__c" \
  --output-dir data \
  --target-org "$ORG_ALIAS"

sf data export tree \
  --query "SELECT Name, Status__c, Cloud__c, Description__c, Problem__c, Solution__c, Architecture__c, Technologies__c, GitHub_Repository__c, Demo_URL__c, Published_Date__c, Start_Date__c, End_Date__c FROM Salesforce_Project__c" \
  --output-dir data \
  --target-org "$ORG_ALIAS"

echo ">> Done. Review data/*.json before committing (strip personal phone/email)."
