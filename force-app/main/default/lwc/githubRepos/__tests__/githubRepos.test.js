import { createElement } from "lwc";
import GithubRepos from "c/githubRepos";
import getRepos from "@salesforce/apex/GitHubReposController.getRepos";

const mockRepos = [
  {
    name: "salesforce-portfolio-app",
    description: "Native Salesforce portfolio",
    language: "Apex",
    stargazersCount: 3,
    htmlUrl: "https://github.com/octocat/salesforce-portfolio-app"
  }
];

jest.mock(
  "@salesforce/apex/GitHubReposController.getRepos",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);

describe("c-github-repos", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    jest.clearAllMocks();
  });

  async function flushPromises() {
    return Promise.resolve();
  }

  it("renders repository cards from Apex", async () => {
    const element = createElement("c-github-repos", { is: GithubRepos });
    document.body.appendChild(element);

    getRepos.emit(mockRepos);
    await flushPromises();

    const cards = element.shadowRoot.querySelectorAll("article");
    expect(cards).toHaveLength(1);
    expect(element.shadowRoot.querySelector("a").textContent).toBe(
      "salesforce-portfolio-app"
    );
  });

  it("shows an error message when the wire fails", async () => {
    const element = createElement("c-github-repos", { is: GithubRepos });
    document.body.appendChild(element);

    getRepos.error({
      body: { message: "GitHub user was not found." },
      status: 400
    });
    await flushPromises();

    const errorNode = element.shadowRoot.querySelector(
      ".slds-text-color_error"
    );
    expect(errorNode).not.toBeNull();
    expect(errorNode.textContent.length).toBeGreaterThan(0);
  });
});
