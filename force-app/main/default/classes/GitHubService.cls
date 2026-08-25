/**
 * Integration service (callout gateway — not a SOQL selector).
 *
 * Reads GitHub_Config__mdt, calls Named Credential GitHub_API, maps JSON into
 * RepoWrapper for the Home LWC. Errors are typed (GitHubException).
 */
public with sharing class GitHubService {
  public class GitHubException extends Exception {
  }

  public class RepoWrapper {
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String description;
    @AuraEnabled
    public String language;
    @AuraEnabled
    public Integer stargazersCount;
    @AuraEnabled
    public String htmlUrl;
  }

  private class GitHubRepoPayload {
    public String name;
    public String description;
    public String language;
    public Integer stargazers_count;
    public String html_url;
  }

  @TestVisible
  static String usernameOverride;
  @TestVisible
  static Integer maxReposOverride;

  public static List<RepoWrapper> getRepos() {
    String username = usernameOverride;
    Integer maxRepos = maxReposOverride;

    if (username == null || maxRepos == null) {
      GitHub_Config__mdt config = GitHub_Config__mdt.getInstance('Default');
      if (config == null) {
        throw new GitHubException(
          'GitHub configuration is missing. Create a GitHub Config record named Default.'
        );
      }
      if (username == null) {
        username = config.Username__c;
      }
      if (maxRepos == null) {
        maxRepos = config.Max_Repos__c == null
          ? 8
          : Integer.valueOf(config.Max_Repos__c);
      }
    }

    if (String.isBlank(username)) {
      throw new GitHubException('GitHub username is not configured.');
    }
    if (maxRepos == null || maxRepos <= 0) {
      maxRepos = 8;
    }

    HttpRequest request = new HttpRequest();
    request.setEndpoint(
      'callout:GitHub_API/users/' +
        EncodingUtil.urlEncode(username, 'UTF-8') +
        '/repos?sort=updated&per_page=' +
        String.valueOf(maxRepos)
    );
    request.setMethod('GET');
    request.setHeader('Accept', 'application/vnd.github+json');
    request.setHeader('User-Agent', 'salesforce-portfolio-app');
    request.setTimeout(12000);

    HttpResponse response = new Http().send(request);
    Integer statusCode = response.getStatusCode();
    String body = response.getBody();

    if (statusCode == 404) {
      throw new GitHubException(
        'GitHub user "' + username + '" was not found.'
      );
    }
    if (statusCode == 403) {
      throw new GitHubException(
        'GitHub API rate limit reached. Try again in a few minutes.'
      );
    }
    if (statusCode < 200 || statusCode >= 300) {
      throw new GitHubException('GitHub API returned HTTP ' + statusCode + '.');
    }
    if (String.isBlank(body)) {
      return new List<RepoWrapper>();
    }

    List<GitHubRepoPayload> payload;
    try {
      payload = (List<GitHubRepoPayload>) JSON.deserialize(
        body,
        List<GitHubRepoPayload>.class
      );
    } catch (Exception ex) {
      throw new GitHubException('GitHub API returned invalid JSON.');
    }

    List<RepoWrapper> repos = new List<RepoWrapper>();
    if (payload == null) {
      return repos;
    }
    for (GitHubRepoPayload item : payload) {
      RepoWrapper repo = new RepoWrapper();
      repo.name = item.name;
      repo.description = item.description;
      repo.language = item.language;
      repo.stargazersCount = item.stargazers_count == null
        ? 0
        : item.stargazers_count;
      repo.htmlUrl = item.html_url;
      repos.add(repo);
    }
    return repos;
  }

  public static String summarizeRepos(List<RepoWrapper> repos) {
    if (repos == null || repos.isEmpty()) {
      return 'No public repositories were returned.';
    }
    List<String> lines = new List<String>();
    for (RepoWrapper repo : repos) {
      String language = String.isBlank(repo.language) ? 'n/a' : repo.language;
      Integer stars = repo.stargazersCount == null ? 0 : repo.stargazersCount;
      lines.add(
        repo.name + ' (' + language + ', ' + String.valueOf(stars) + ' stars)'
      );
    }
    return String.join(lines, '; ');
  }
}
