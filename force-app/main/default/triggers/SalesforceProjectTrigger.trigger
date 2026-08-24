trigger SalesforceProjectTrigger on Salesforce_Project__c(
  before insert,
  before update
) {
  SalesforceProjectTriggerHandler.handle(Trigger.new, Trigger.oldMap);
}
