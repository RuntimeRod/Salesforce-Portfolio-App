/**
 * Invocable adapter for Flow and Agentforce. Delegates to GitHubService.
 */
public with sharing class GitHubReposInvocable {
  public class Request {
    @InvocableVariable(
      label='Unused'
      description='Optional placeholder so Agentforce can invoke this action'
    )
    public String unused;
  }

  public class Result {
    @InvocableVariable(label='Summary')
    public String summary;
    @InvocableVariable(label='Repository Count')
    public Integer repositoryCount;
  }

  @InvocableMethod(
    label='Get GitHub Repositories'
    description='Returns public GitHub repositories using Named Credential + Custom Metadata. Used later by Agentforce.'
  )
  public static List<Result> getRepos(List<Request> requests) {
    List<GitHubService.RepoWrapper> repos = GitHubService.getRepos();
    Result template = new Result();
    template.summary = GitHubService.summarizeRepos(repos);
    template.repositoryCount = repos.size();

    Integer size = requests == null || requests.isEmpty() ? 1 : requests.size();
    List<Result> results = new List<Result>();
    for (Integer i = 0; i < size; i++) {
      results.add(template);
    }
    return results;
  }
}
