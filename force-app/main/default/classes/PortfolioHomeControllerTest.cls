@IsTest
private class PortfolioHomeControllerTest {
  @IsTest
  static void getShowcase_returnsProfileStatsAndPublishedProjects() {
    insert new About_Me__c(
      Name = 'Rodrigo Moreira',
      Title__c = 'Salesforce Developer',
      Headline__c = 'Platform Developer I',
      Location__c = 'Rio de Janeiro, Brazil',
      Bio__c = 'Builds Apex and LWC solutions.'
    );
    insert new Contact_Info__c(
      Name = 'Primary',
      LinkedIn__c = 'https://www.linkedin.com/in/rodmoreira1312/',
      GitHub__c = 'https://github.com/RuntimeRod',
      Trailhead__c = 'https://www.salesforce.com/trailblazer/rodmoreira'
    );
    insert new Salesforce_Project__c(
      Name = 'Portfolio App',
      Status__c = 'Published',
      Cloud__c = 'Platform;Experience Cloud',
      Description__c = 'Native Salesforce portfolio.',
      GitHub_Repository__c = 'https://github.com/RuntimeRod/salesforce-portfolio-app',
      Demo_URL__c = 'https://github.com/RuntimeRod/salesforce-portfolio-app'
    );
    insert new Certification__c(
      Name = 'Platform Developer I',
      Status__c = 'Active'
    );
    insert new Skill__c(
      Name = 'Apex',
      Category__c = 'Salesforce',
      Level__c = 'Advanced'
    );

    Test.startTest();
    PortfolioHomeController.Showcase showcase = PortfolioHomeController.getShowcase();
    Test.stopTest();

    System.assertEquals('Rodrigo Moreira', showcase.profile.name);
    System.assertEquals('RM', showcase.profile.initials);
    System.assertEquals(4, showcase.stats.size());
    System.assertEquals(1, showcase.projects.size());
    System.assertEquals(2, showcase.projects[0].clouds.size());
    System.assert(showcase.profile.gitHub.contains('RuntimeRod'));
  }

  @IsTest
  static void getShowcase_handlesEmptyOrg() {
    Test.startTest();
    PortfolioHomeController.Showcase showcase = PortfolioHomeController.getShowcase();
    Test.stopTest();

    System.assertNotEquals(null, showcase.profile);
    System.assertEquals(4, showcase.stats.size());
    System.assertEquals(0, showcase.projects.size());
  }
}
