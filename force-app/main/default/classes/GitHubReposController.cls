/**
 * Thin AuraEnabled adapter. LWC never talks to GitHubService directly.
 */
public with sharing class GitHubReposController {
  @AuraEnabled(cacheable=true)
  public static List<GitHubService.RepoWrapper> getRepos() {
    try {
      return GitHubService.getRepos();
    } catch (Exception ex) {
      throw new AuraHandledException(ex.getMessage());
    }
  }
}
