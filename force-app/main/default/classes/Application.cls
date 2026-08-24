/**
 * fflib-style Application factory.
 *
 * Callers never `new` selector/domain directly. That keeps construction in one
 * place (the same idea as fflib's Application class) and lets tests inject stubs
 * via the @TestVisible overrides.
 *
 * This project applies Apex Enterprise Patterns (Andrew Fawcett / fflib) without
 * vendoring the unmanaged fflib-apex-common package — the layers are the point,
 * not the extra Unit of Work/factory machinery for a single-object portfolio.
 */
public with sharing class Application {
  @TestVisible
  static SalesforceProjectSelector selectorOverride;
  @TestVisible
  static SalesforceProjectDomain domainOverride;

  public static SalesforceProjectSelector selector() {
    return selectorOverride != null
      ? selectorOverride
      : new SalesforceProjectSelector();
  }

  public static SalesforceProjectDomain domain(
    List<Salesforce_Project__c> records,
    Map<Id, Salesforce_Project__c> oldMap
  ) {
    return domainOverride != null
      ? domainOverride
      : new SalesforceProjectDomain(records, oldMap);
  }
}
