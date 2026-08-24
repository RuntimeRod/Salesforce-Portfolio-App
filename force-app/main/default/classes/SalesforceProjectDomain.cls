/**
 * Domain layer (fflib SObjectDomain).
 *
 * Record behaviour for Salesforce_Project__c: validation and defaulting that must
 * run in a before trigger, bulk-safe on the in-memory list. No SOQL, no callouts.
 */
public with sharing class SalesforceProjectDomain {
  public static final String STATUS_PUBLISHED = 'Published';

  private List<Salesforce_Project__c> records;
  private Map<Id, Salesforce_Project__c> oldMap;

  public SalesforceProjectDomain(
    List<Salesforce_Project__c> records,
    Map<Id, Salesforce_Project__c> oldMap
  ) {
    this.records = records == null
      ? new List<Salesforce_Project__c>()
      : records;
    this.oldMap = oldMap;
  }

  /**
   * Published records need a description; first transition to Published stamps the date.
   * Link URLs stay in a Validation Rule (declarative where it is enough).
   */
  public void applyPublishRules() {
    for (Salesforce_Project__c project : records) {
      if (project.Status__c != STATUS_PUBLISHED) {
        continue;
      }

      if (String.isBlank(project.Description__c)) {
        project.addError('A description is required to publish a project.');
        continue;
      }

      Salesforce_Project__c previous = oldMap == null
        ? null
        : oldMap.get(project.Id);
      Boolean justPublished =
        previous == null ||
        previous.Status__c != STATUS_PUBLISHED;
      if (justPublished && project.Published_Date__c == null) {
        project.Published_Date__c = Date.today();
      }
    }
  }
}
