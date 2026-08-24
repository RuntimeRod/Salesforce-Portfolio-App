@IsTest
private class GitHubServiceTest {
  private class SuccessMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
      System.assert(
        request.getEndpoint().contains('/users/'),
        'Endpoint should target GitHub users API'
      );
      HttpResponse response = new HttpResponse();
      response.setStatusCode(200);
      response.setHeader('Content-Type', 'application/json');
      response.setBody(
        '[{"name":"salesforce-portfolio-app","description":"Portfolio app","language":"Apex","stargazers_count":4,"html_url":"https://github.com/octocat/salesforce-portfolio-app"}]'
      );
      return response;
    }
  }

  private class StatusMock implements HttpCalloutMock {
    Integer statusCode;
    String body;
    StatusMock(Integer statusCode, String body) {
      this.statusCode = statusCode;
      this.body = body;
    }
    public HTTPResponse respond(HTTPRequest request) {
      HttpResponse response = new HttpResponse();
      response.setStatusCode(statusCode);
      response.setBody(body);
      return response;
    }
  }

  @IsTest
  static void getRepos_success() {
    GitHubService.usernameOverride = 'octocat';
    GitHubService.maxReposOverride = 5;
    Test.setMock(HttpCalloutMock.class, new SuccessMock());

    Test.startTest();
    List<GitHubService.RepoWrapper> repos = GitHubService.getRepos();
    Test.stopTest();

    System.assertEquals(1, repos.size());
    System.assertEquals('salesforce-portfolio-app', repos[0].name);
    System.assertEquals('Apex', repos[0].language);
    System.assertEquals(4, repos[0].stargazersCount);
    System.assert(
      GitHubService.summarizeRepos(repos).contains('salesforce-portfolio-app'),
      'Summary should include the repository name'
    );
  }

  @IsTest
  static void getRepos_notFound() {
    GitHubService.usernameOverride = 'missing-user';
    GitHubService.maxReposOverride = 5;
    Test.setMock(
      HttpCalloutMock.class,
      new StatusMock(404, '{"message":"Not Found"}')
    );

    GitHubService.GitHubException caught;
    Test.startTest();
    try {
      GitHubService.getRepos();
    } catch (GitHubService.GitHubException ex) {
      caught = ex;
    }
    Test.stopTest();

    System.assertNotEquals(null, caught);
    System.assert(caught.getMessage().contains('was not found'));
  }

  @IsTest
  static void getRepos_rateLimited() {
    GitHubService.usernameOverride = 'octocat';
    GitHubService.maxReposOverride = 5;
    Test.setMock(
      HttpCalloutMock.class,
      new StatusMock(403, '{"message":"API rate limit exceeded"}')
    );

    GitHubService.GitHubException caught;
    Test.startTest();
    try {
      GitHubService.getRepos();
    } catch (GitHubService.GitHubException ex) {
      caught = ex;
    }
    Test.stopTest();

    System.assertNotEquals(null, caught);
    System.assert(caught.getMessage().contains('rate limit'));
  }

  @IsTest
  static void getRepos_invalidJson() {
    GitHubService.usernameOverride = 'octocat';
    GitHubService.maxReposOverride = 5;
    Test.setMock(HttpCalloutMock.class, new StatusMock(200, 'not-json'));

    GitHubService.GitHubException caught;
    Test.startTest();
    try {
      GitHubService.getRepos();
    } catch (GitHubService.GitHubException ex) {
      caught = ex;
    }
    Test.stopTest();

    System.assertNotEquals(null, caught);
    System.assert(caught.getMessage().contains('invalid JSON'));
  }

  @IsTest
  static void getRepos_blankUsername() {
    GitHubService.usernameOverride = '';
    GitHubService.maxReposOverride = 5;

    GitHubService.GitHubException caught;
    try {
      GitHubService.getRepos();
    } catch (GitHubService.GitHubException ex) {
      caught = ex;
    }
    System.assertNotEquals(null, caught);
    System.assert(caught.getMessage().contains('username'));
  }

  @IsTest
  static void getRepos_usesCustomMetadata() {
    GitHubService.usernameOverride = null;
    GitHubService.maxReposOverride = null;
    Test.setMock(HttpCalloutMock.class, new SuccessMock());

    Test.startTest();
    List<GitHubService.RepoWrapper> repos = GitHubService.getRepos();
    Test.stopTest();

    System.assertEquals(1, repos.size());
  }

  @IsTest
  static void getRepos_unexpectedStatus() {
    GitHubService.usernameOverride = 'octocat';
    GitHubService.maxReposOverride = 5;
    Test.setMock(
      HttpCalloutMock.class,
      new StatusMock(500, '{"message":"boom"}')
    );

    GitHubService.GitHubException caught;
    Test.startTest();
    try {
      GitHubService.getRepos();
    } catch (GitHubService.GitHubException ex) {
      caught = ex;
    }
    Test.stopTest();

    System.assertNotEquals(null, caught);
    System.assert(caught.getMessage().contains('HTTP 500'));
  }

  @IsTest
  static void summarizeRepos_empty() {
    System.assertEquals(
      'No public repositories were returned.',
      GitHubService.summarizeRepos(new List<GitHubService.RepoWrapper>())
    );
  }
}
