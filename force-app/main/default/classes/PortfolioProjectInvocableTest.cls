@IsTest
private class PortfolioProjectInvocableTest {
  @IsTest
  static void getProjects_filtersByCloudAndStatus() {
    insert new List<Salesforce_Project__c>{
      new Salesforce_Project__c(
        Name = 'Micromed Portal',
        Status__c = 'Draft',
        Cloud__c = 'Experience Cloud',
        Description__c = 'Self-service portal.',
        GitHub_Repository__c = 'https://github.com/example/micromed',
        Demo_URL__c = 'https://example.com/micromed'
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
    request.cloud = 'Experience Cloud';
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
    System.assert(results[0].summary.contains('Micromed Portal'));
    System.assertEquals(0, empty[0].projectCount);
  }
}
