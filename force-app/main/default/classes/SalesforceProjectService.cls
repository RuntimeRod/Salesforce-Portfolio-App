/**
 * Service layer (fflib service).
 *
 * Orchestrates selector + presentation for UI, Flow and Agentforce.
 * Does not own SOQL (selector) or trigger field rules (domain).
 */
public with sharing class SalesforceProjectService {
  public static List<Salesforce_Project__c> getProjects(
    String cloud,
    String status
  ) {
    return Application.selector().selectByCloudAndStatus(cloud, status);
  }

  public static String summarizeProjects(List<Salesforce_Project__c> projects) {
    if (projects == null || projects.isEmpty()) {
      return 'No Salesforce projects matched the filters.';
    }
    List<String> lines = new List<String>();
    for (Salesforce_Project__c project : projects) {
      String cloud = String.isBlank(project.Cloud__c)
        ? 'n/a'
        : project.Cloud__c;
      lines.add(project.Name + ' [' + project.Status__c + ' / ' + cloud + ']');
    }
    return String.join(lines, '; ');
  }
}
