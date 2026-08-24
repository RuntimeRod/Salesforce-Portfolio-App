/**
 * Selector layer (fflib SObjectSelector).
 *
 * Owns every SOQL for Salesforce_Project__c. No DML, no addError, no callouts.
 * Methods are virtual so a test stub can extend this class without hitting the DB.
 */
public virtual with sharing class SalesforceProjectSelector {
  /**
   * Returns up to 50 projects, optionally filtered by Cloud (includes) and Status.
   * Uses bind variables — never concatenates user input into SOQL.
   */
  public virtual List<Salesforce_Project__c> selectByCloudAndStatus(
    String cloud,
    String status
  ) {
    Boolean hasCloud = String.isNotBlank(cloud);
    Boolean hasStatus = String.isNotBlank(status);

    if (hasCloud && hasStatus) {
      return [
        SELECT Id, Name, Status__c, Cloud__c, Description__c, Technologies__c
        FROM Salesforce_Project__c
        WHERE Status__c = :status AND Cloud__c INCLUDES (:cloud)
        ORDER BY Name
        LIMIT 50
      ];
    }
    if (hasStatus) {
      return [
        SELECT Id, Name, Status__c, Cloud__c, Description__c, Technologies__c
        FROM Salesforce_Project__c
        WHERE Status__c = :status
        ORDER BY Name
        LIMIT 50
      ];
    }
    if (hasCloud) {
      return [
        SELECT Id, Name, Status__c, Cloud__c, Description__c, Technologies__c
        FROM Salesforce_Project__c
        WHERE Cloud__c INCLUDES (:cloud)
        ORDER BY Name
        LIMIT 50
      ];
    }
    return [
      SELECT Id, Name, Status__c, Cloud__c, Description__c, Technologies__c
      FROM Salesforce_Project__c
      ORDER BY Name
      LIMIT 50
    ];
  }

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
