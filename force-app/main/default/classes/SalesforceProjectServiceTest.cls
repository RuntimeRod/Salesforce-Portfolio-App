@IsTest
private class SalesforceProjectServiceTest {
  @IsTest
  static void getProjects_usesSelector() {
    insert new Salesforce_Project__c(
      Name = 'Experience Portal',
      Status__c = 'Draft',
      Cloud__c = 'Experience Cloud;Service Cloud',
      Description__c = 'Portal for partners.',
      GitHub_Repository__c = 'https://github.com/example/portal',
      Demo_URL__c = 'https://example.com/portal'
    );

    Test.startTest();
    List<Salesforce_Project__c> matches = SalesforceProjectService.getProjects(
      'Experience Cloud',
      'Draft'
    );
    String summary = SalesforceProjectService.summarizeProjects(matches);
    String emptySummary = SalesforceProjectService.summarizeProjects(
      new List<Salesforce_Project__c>()
    );
    Test.stopTest();

    System.assertEquals(1, matches.size());
    System.assert(summary.contains('Experience Portal'));
    System.assert(emptySummary.contains('No Salesforce projects matched'));
  }
}
