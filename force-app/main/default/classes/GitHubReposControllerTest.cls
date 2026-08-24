@IsTest
private class GitHubReposControllerTest {
  private class SuccessMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
      HttpResponse response = new HttpResponse();
      response.setStatusCode(200);
      response.setBody(
        '[{"name":"demo","description":"Demo repo","language":"JavaScript","stargazers_count":1,"html_url":"https://github.com/octocat/demo"}]'
      );
      return response;
    }
  }

  private class ErrorMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
      HttpResponse response = new HttpResponse();
      response.setStatusCode(500);
      response.setBody('{"message":"boom"}');
      return response;
    }
  }

  @IsTest
  static void getRepos_success() {
    GitHubService.usernameOverride = 'octocat';
    GitHubService.maxReposOverride = 3;
    Test.setMock(HttpCalloutMock.class, new SuccessMock());

    Test.startTest();
    List<GitHubService.RepoWrapper> repos = GitHubReposController.getRepos();
    Test.stopTest();

    System.assertEquals(1, repos.size());
    System.assertEquals('demo', repos[0].name);
  }

  @IsTest
  static void getRepos_wrapsErrors() {
    GitHubService.usernameOverride = 'octocat';
    GitHubService.maxReposOverride = 3;
    Test.setMock(HttpCalloutMock.class, new ErrorMock());

    AuraHandledException caught;
    Test.startTest();
    try {
      GitHubReposController.getRepos();
    } catch (AuraHandledException ex) {
      caught = ex;
    }
    Test.stopTest();

    System.assertNotEquals(null, caught);
  }
}
