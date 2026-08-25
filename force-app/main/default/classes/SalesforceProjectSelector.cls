/**
 * Selector layer (fflib SObjectSelector).
 *
 * Owns SOQL for Salesforce_Project__c used by the Home LWC. No DML, no addError.
 */
public virtual with sharing class SalesforceProjectSelector {
  public virtual List<Salesforce_Project__c> selectPublished(
    Integer recordLimit
  ) {
    Integer safeLimit = recordLimit == null ||
      recordLimit < 1
      ? 4
      : recordLimit;
    return [
      SELECT
        Id,
        Name,
        Status__c,
        Cloud__c,
        Description__c,
        Technologies__c,
        Demo_URL__c,
        GitHub_Repository__c
      FROM Salesforce_Project__c
      WHERE Status__c = 'Published'
      ORDER BY Published_Date__c DESC NULLS LAST, Name ASC
      LIMIT :safeLimit
    ];
  }
}
