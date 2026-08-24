@IsTest
private class PortfolioProjectInvocableTest {
  @IsTest
  static void getProjects_filtersByCloudAndStatus() {
    insert new List<Salesforce_Project__c>{
      new Salesforce_Project__c(
        Name = 'Platform Lab',
        Status__c = 'Draft',
        Cloud__c = 'Platform',
        Description__c = 'Sample published-style record for tests.',
        GitHub_Repository__c = 'https://github.com/example/platform-lab',
        Demo_URL__c = 'https://example.com/platform-lab'
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

    PortfolioProjectInvocable.Request request = new PortfolioProjectInvocable.Request();
    request.cloud = 'Platform';
    request.status = 'Draft';

    Test.startTest();
    List<PortfolioProjectInvocable.Result> results = PortfolioProjectInvocable.getProjects(
      new List<PortfolioProjectInvocable.Request>{ request }
    );
    List<PortfolioProjectInvocable.Result> empty = PortfolioProjectInvocable.getProjects(
      new List<PortfolioProjectInvocable.Request>()
    );
    Test.stopTest();

    System.assertEquals(1, results.size());
    System.assertEquals(1, results[0].projectCount);
    System.assert(results[0].summary.contains('Platform Lab'));
    System.assertEquals(0, empty[0].projectCount);
  }
}
