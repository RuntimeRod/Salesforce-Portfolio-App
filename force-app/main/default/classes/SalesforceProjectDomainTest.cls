@IsTest
private class SalesforceProjectDomainTest {
  @IsTest
  static void publishedWithoutDescription_addsError() {
    Salesforce_Project__c project = new Salesforce_Project__c(
      Name = 'No Description',
      Status__c = 'Published'
    );

    new SalesforceProjectDomain(
        new List<Salesforce_Project__c>{ project },
        null
      )
      .applyPublishRules();

    System.assert(
      project.hasErrors(),
      'Published projects without a description must error'
    );
    System.assertEquals(null, project.Published_Date__c);
  }

  @IsTest
  static void publishedWithDescription_stampsDate() {
    Salesforce_Project__c project = new Salesforce_Project__c(
      Name = 'Ready',
      Status__c = 'Published',
      Description__c = 'A complete description of the solution.'
    );

    new SalesforceProjectDomain(
        new List<Salesforce_Project__c>{ project },
        null
      )
      .applyPublishRules();

    System.assertEquals(false, project.hasErrors());
    System.assertEquals(Date.today(), project.Published_Date__c);
  }

  @IsTest
  static void draft_isIgnored() {
    Salesforce_Project__c project = new Salesforce_Project__c(
      Name = 'Draft Work',
      Status__c = 'Draft'
    );

    new SalesforceProjectDomain(
        new List<Salesforce_Project__c>{ project },
        null
      )
      .applyPublishRules();

    System.assertEquals(false, project.hasErrors());
    System.assertEquals(null, project.Published_Date__c);
  }

  @IsTest
  static void nullList_doesNotThrow() {
    new SalesforceProjectDomain(null, null).applyPublishRules();
    System.assert(true, 'Empty domain list is a no-op');
  }
}
