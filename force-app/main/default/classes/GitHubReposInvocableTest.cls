@IsTest
private class GitHubReposInvocableTest {
  private class SuccessMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
      HttpResponse response = new HttpResponse();
      response.setStatusCode(200);
      response.setBody(
        '[{"name":"demo","description":null,"language":null,"stargazers_count":null,"html_url":"https://github.com/octocat/demo"}]'
      );
      return response;
    }
  }

  @IsTest
  static void getRepos_returnsSummary() {
    GitHubService.usernameOverride = 'octocat';
    GitHubService.maxReposOverride = 2;
    Test.setMock(HttpCalloutMock.class, new SuccessMock());

    Test.startTest();
    List<GitHubReposInvocable.Result> results = GitHubReposInvocable.getRepos(
      new List<GitHubReposInvocable.Request>{
        new GitHubReposInvocable.Request()
      }
    );
    Test.stopTest();

    System.assertEquals(1, results.size());
    System.assertEquals(1, results[0].repositoryCount);
    System.assert(results[0].summary.contains('demo'));
  }
}
