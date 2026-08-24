@IsTest
private class SalesforceProjectSelectorTest {
  @IsTest
  static void selectByCloudAndStatus_filtersBoth() {
    insert new List<Salesforce_Project__c>{
      new Salesforce_Project__c(
        Name = 'Experience Portal',
        Status__c = 'Draft',
        Cloud__c = 'Experience Cloud;Service Cloud',
        Description__c = 'Portal for partners.',
        GitHub_Repository__c = 'https://github.com/example/portal',
        Demo_URL__c = 'https://example.com/portal'
      ),
      new Salesforce_Project__c(
        Name = 'Sales Funnel',
        Status__c = 'Draft',
        Cloud__c = 'Sales Cloud',
        Description__c = 'Lead conversion.',
        GitHub_Repository__c = 'https://github.com/example/sales',
        Demo_URL__c = 'https://example.com/sales'
      )
    };

    Test.startTest();
    List<Salesforce_Project__c> both = new SalesforceProjectSelector()
      .selectByCloudAndStatus('Experience Cloud', 'Draft');
    List<Salesforce_Project__c> statusOnly = new SalesforceProjectSelector()
      .selectByCloudAndStatus(null, 'Draft');
    List<Salesforce_Project__c> cloudOnly = new SalesforceProjectSelector()
      .selectByCloudAndStatus('Sales Cloud', null);
    List<Salesforce_Project__c> allRows = new SalesforceProjectSelector()
      .selectByCloudAndStatus(null, null);
    Test.stopTest();

    System.assertEquals(1, both.size());
    System.assertEquals('Experience Portal', both[0].Name);
    System.assertEquals(2, statusOnly.size());
    System.assertEquals(1, cloudOnly.size());
    System.assert(allRows.size() >= 2);
  }

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
