/**
 * App Home: profile, counts and published project cards from PortfolioHomeController.
 */
import { LightningElement, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getShowcase from "@salesforce/apex/PortfolioHomeController.getShowcase";

export default class PortfolioHome extends NavigationMixin(LightningElement) {
  isLoading = true;
  profile = {};
  stats = [];
  projects = [];

  @wire(getShowcase)
  wiredShowcase({ data, error }) {
    this.isLoading = false;
    if (data) {
      this.profile = data.profile || {};
      this.stats = data.stats || [];
      this.projects = data.projects || [];
    } else if (error) {
      this.profile = {};
      this.stats = [];
      this.projects = [];
    }
  }

  get name() {
    return this.profile.name || "Salesforce Portfolio";
  }

  get title() {
    return this.profile.title || "Salesforce Developer";
  }

  get headline() {
    return this.profile.headline || "";
  }

  get location() {
    return this.profile.location || "";
  }

  get bio() {
    return this.profile.bio || "";
  }

  get initials() {
    return this.profile.initials || "SP";
  }

  get linkedIn() {
    return this.profile.linkedIn;
  }

  get gitHub() {
    return this.profile.gitHub;
  }

  get trailhead() {
    return this.profile.trailhead;
  }

  get hasStats() {
    return this.stats.length > 0;
  }

  get hasProjects() {
    return this.projects.length > 0;
  }

  openProject(event) {
    const recordId = event.currentTarget.dataset.id;
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId,
        objectApiName: "Salesforce_Project__c",
        actionName: "view"
      }
    });
  }
}
