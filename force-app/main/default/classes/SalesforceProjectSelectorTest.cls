@IsTest
private class SalesforceProjectSelectorTest {
  @IsTest
  static void selectPublished_returnsPublishedOnly() {
    insert new List<Salesforce_Project__c>{
      new Salesforce_Project__c(
        Name = 'Live App',
        Status__c = 'Published',
        Cloud__c = 'Platform',
        Description__c = 'Published case study.',
        GitHub_Repository__c = 'https://github.com/example/live',
        Demo_URL__c = 'https://example.com/live'
      ),
      new Salesforce_Project__c(
        Name = 'Draft App',
        Status__c = 'Draft',
        Cloud__c = 'Platform',
        Description__c = 'Still writing.'
      )
    };

    Test.startTest();
    List<Salesforce_Project__c> published = new SalesforceProjectSelector()
      .selectPublished(4);
    Test.stopTest();

    System.assertEquals(1, published.size());
    System.assertEquals('Live App', published[0].Name);
  }
}
