/**
 * Trigger handler (one trigger per object).
 *
 * Routes Trigger context into the domain. No business rules here — if after-save
 * logic appears later, add afterInsert/afterUpdate methods in this class.
 */
public with sharing class SalesforceProjectTriggerHandler {
  public static void handle(
    List<Salesforce_Project__c> records,
    Map<Id, Salesforce_Project__c> oldMap
  ) {
    Application.domain(records, oldMap).applyPublishRules();
  }
}
