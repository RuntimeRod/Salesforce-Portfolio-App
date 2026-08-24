/**
 * Home-page widget: live public repos from GitHub via GitHubReposController.
 * Loading / error / empty / cards — no Apex logic in the browser.
 */
import { LightningElement, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getRepos from "@salesforce/apex/GitHubReposController.getRepos";

export default class GithubRepos extends LightningElement {
  isLoading = true;
  repos = [];
  errorMessage;

  @wire(getRepos)
  wiredRepos({ data, error }) {
    this.isLoading = false;
    if (data) {
      this.repos = data;
      this.errorMessage = undefined;
    } else if (error) {
      this.repos = [];
      this.errorMessage = this.reduceError(error);
      this.dispatchEvent(
        new ShowToastEvent({
          title: "GitHub repositories",
          message: this.errorMessage,
          variant: "error"
        })
      );
    }
  }

  get hasRepos() {
    return Array.isArray(this.repos) && this.repos.length > 0;
  }

  reduceError(error) {
    if (!error) {
      return "Unable to load GitHub repositories.";
    }
    if (Array.isArray(error.body)) {
      return error.body.map((item) => item.message).join(", ");
    }
    if (error.body && error.body.message) {
      return error.body.message;
    }
    return error.message || "Unable to load GitHub repositories.";
  }
}
