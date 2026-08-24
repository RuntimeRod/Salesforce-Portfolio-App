/**
 * AuraEnabled adapter for the Home LWC. Profile/stats SOQL stays here;
 * published projects go through Application.selector().
 */
public with sharing class PortfolioHomeController {
  public class ProfileCard {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String title;
    @AuraEnabled
    public String headline;
    @AuraEnabled
    public String location;
    @AuraEnabled
    public String bio;
    @AuraEnabled
    public String initials;
    @AuraEnabled
    public String linkedIn;
    @AuraEnabled
    public String gitHub;
    @AuraEnabled
    public String trailhead;
  }

  public class Stat {
    @AuraEnabled
    public String label;
    @AuraEnabled
    public Integer value;
    @AuraEnabled
    public String icon;
  }

  public class ProjectCard {
    @AuraEnabled
    public Id id;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String description;
    @AuraEnabled
    public String technologies;
    @AuraEnabled
    public String demoUrl;
    @AuraEnabled
    public String gitHubUrl;
    @AuraEnabled
    public List<String> clouds;
  }

  public class Showcase {
    @AuraEnabled
    public ProfileCard profile;
    @AuraEnabled
    public List<Stat> stats;
    @AuraEnabled
    public List<ProjectCard> projects;
  }

  @AuraEnabled(cacheable=true)
  public static Showcase getShowcase() {
    try {
      Showcase showcase = new Showcase();
      showcase.profile = loadProfile();
      showcase.stats = loadStats();
      showcase.projects = loadProjects();
      return showcase;
    } catch (Exception ex) {
      throw new AuraHandledException(ex.getMessage());
    }
  }

  static ProfileCard loadProfile() {
    ProfileCard card = new ProfileCard();
    List<About_Me__c> about = [
      SELECT Name, Title__c, Headline__c, Location__c, Bio__c
      FROM About_Me__c
      ORDER BY CreatedDate DESC
      LIMIT 1
    ];
    if (!about.isEmpty()) {
      About_Me__c row = about[0];
      card.name = row.Name;
      card.title = row.Title__c;
      card.headline = row.Headline__c;
      card.location = row.Location__c;
      card.bio = row.Bio__c;
      card.initials = initialsFor(row.Name);
    }

    List<Contact_Info__c> contacts = [
      SELECT LinkedIn__c, GitHub__c, Trailhead__c, City__c
      FROM Contact_Info__c
      ORDER BY CreatedDate DESC
      LIMIT 1
    ];
    if (!contacts.isEmpty()) {
      Contact_Info__c contact = contacts[0];
      card.linkedIn = contact.LinkedIn__c;
      card.gitHub = contact.GitHub__c;
      card.trailhead = contact.Trailhead__c;
      if (String.isBlank(card.location)) {
        card.location = contact.City__c;
      }
    }
    return card;
  }

  static List<Stat> loadStats() {
    List<Stat> stats = new List<Stat>();
    stats.add(
      stat(
        'Projects',
        [SELECT COUNT() FROM Salesforce_Project__c],
        'utility:layers'
      )
    );
    stats.add(
      stat(
        'Published',
        [
          SELECT COUNT()
          FROM Salesforce_Project__c
          WHERE Status__c = 'Published'
        ],
        'utility:success'
      )
    );
    stats.add(
      stat(
        'Certifications',
        [SELECT COUNT() FROM Certification__c],
        'utility:ribbon'
      )
    );
    stats.add(
      stat('Skills', [SELECT COUNT() FROM Skill__c], 'utility:knowledge_base')
    );
    return stats;
  }

  static List<ProjectCard> loadProjects() {
    List<ProjectCard> cards = new List<ProjectCard>();
    for (
      Salesforce_Project__c project : Application.selector().selectPublished(4)
    ) {
      ProjectCard card = new ProjectCard();
      card.id = project.Id;
      card.name = project.Name;
      card.description = project.Description__c;
      card.technologies = project.Technologies__c;
      card.demoUrl = project.Demo_URL__c;
      card.gitHubUrl = project.GitHub_Repository__c;
      card.clouds = splitClouds(project.Cloud__c);
      cards.add(card);
    }
    return cards;
  }

  static Stat stat(String label, Integer value, String icon) {
    Stat item = new Stat();
    item.label = label;
    item.value = value;
    item.icon = icon;
    return item;
  }

  static List<String> splitClouds(String cloud) {
    List<String> values = new List<String>();
    if (String.isBlank(cloud)) {
      return values;
    }
    for (String part : cloud.split(';')) {
      String trimmed = part.trim();
      if (String.isNotBlank(trimmed)) {
        values.add(trimmed);
      }
    }
    return values;
  }

  static String initialsFor(String name) {
    if (String.isBlank(name)) {
      return 'RM';
    }
    List<String> parts = name.trim().split('\\s+');
    String initials = parts[0].substring(0, 1);
    if (parts.size() > 1) {
      initials += parts[parts.size() - 1].substring(0, 1);
    }
    return initials.toUpperCase();
  }
}
