/**
 * Invocable adapter for Flow and Agentforce. Delegates to SalesforceProjectService.
 */
public with sharing class PortfolioProjectInvocable {
  public class Request {
    @InvocableVariable(
      label='Cloud'
      description='Optional Cloud picklist value, e.g. Platform'
    )
    public String cloud;
    @InvocableVariable(
      label='Status'
      description='Optional Status picklist value, e.g. Published'
    )
    public String status;
  }

  public class Result {
    @InvocableVariable(label='Summary')
    public String summary;
    @InvocableVariable(label='Project Count')
    public Integer projectCount;
  }

  @InvocableMethod(
    label='Get Portfolio Projects'
    description='Returns Salesforce Project records filtered by Cloud and/or Status. Used by Flow and later by Agentforce.'
  )
  public static List<Result> getProjects(List<Request> requests) {
    List<Result> results = new List<Result>();
    if (requests == null || requests.isEmpty()) {
      results.add(emptyResult());
      return results;
    }

    for (Request request : requests) {
      String cloud = request == null ? null : request.cloud;
      String status = request == null ? null : request.status;
      List<Salesforce_Project__c> projects = SalesforceProjectService.getProjects(
        cloud,
        status
      );
      Result result = new Result();
      result.summary = SalesforceProjectService.summarizeProjects(projects);
      result.projectCount = projects.size();
      results.add(result);
    }
    return results;
  }

  private static Result emptyResult() {
    Result result = new Result();
    result.summary = SalesforceProjectService.summarizeProjects(
      new List<Salesforce_Project__c>()
    );
    result.projectCount = 0;
    return result;
  }
}
