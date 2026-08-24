@IsTest
private class SalesforceProjectTriggerHandlerTest {
  private static Salesforce_Project__c buildProject(
    String name,
    String status
  ) {
    return new Salesforce_Project__c(
      Name = name,
      Status__c = status,
      Description__c = 'Business problem, solution and architecture notes.',
      GitHub_Repository__c = 'https://github.com/example/' +
        name.replace(' ', '-').toLowerCase(),
      Demo_URL__c = 'https://example.com/' +
        name.replace(' ', '-').toLowerCase()
    );
  }

  @IsTest
  static void bulkPublish_stampsDates() {
    List<Salesforce_Project__c> projects = new List<Salesforce_Project__c>();
    for (Integer i = 0; i < 200; i++) {
      projects.add(buildProject('Bulk Project ' + i, 'Draft'));
    }
    insert projects;

    for (Salesforce_Project__c project : projects) {
      project.Status__c = 'Published';
    }

    Test.startTest();
    update projects;
    Test.stopTest();

    Integer stamped = [
      SELECT COUNT()
      FROM Salesforce_Project__c
      WHERE Published_Date__c = :Date.today()
    ];
    System.assertEquals(200, stamped);
  }

  @IsTest
  static void publishWithoutDescription_isBlocked() {
    Salesforce_Project__c project = buildProject('Blocked', 'Draft');
    project.Description__c = null;
    insert project;

    project.Status__c = 'Published';
    DmlException caught;
    try {
      update project;
    } catch (DmlException ex) {
      caught = ex;
    }
    System.assertNotEquals(null, caught);
    System.assert(caught.getMessage().contains('description'));
  }

  @IsTest
  static void handlerDelegates() {
    Salesforce_Project__c project = buildProject('Direct', 'Published');
    SalesforceProjectTriggerHandler.handle(
      new List<Salesforce_Project__c>{ project },
      null
    );
    System.assertEquals(Date.today(), project.Published_Date__c);
  }
}
