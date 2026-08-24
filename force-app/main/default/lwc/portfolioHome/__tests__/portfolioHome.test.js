import { createElement } from "lwc";
import PortfolioHome from "c/portfolioHome";
import getShowcase from "@salesforce/apex/PortfolioHomeController.getShowcase";

const mockShowcase = {
  profile: {
    name: "Rodrigo Moreira",
    title: "Salesforce Developer",
    headline: "Platform Developer I",
    location: "Rio de Janeiro, Brazil",
    bio: "Builds Apex and LWC solutions.",
    initials: "RM",
    linkedIn: "https://www.linkedin.com/in/rodmoreira1312/",
    gitHub: "https://github.com/RuntimeRod",
    trailhead: "https://www.salesforce.com/trailblazer/rodmoreira"
  },
  stats: [
    { label: "Projects", value: 1, icon: "utility:layers" },
    { label: "Published", value: 1, icon: "utility:success" }
  ],
  projects: [
    {
      id: "a00xx0000000001AAA",
      name: "Salesforce Portfolio App",
      description: "Native Salesforce portfolio.",
      technologies: "Apex, LWC",
      demoUrl: "https://github.com/RuntimeRod/Salesforce-Portfolio-App",
      gitHubUrl: "https://github.com/RuntimeRod/Salesforce-Portfolio-App",
      clouds: ["Platform"]
    }
  ]
};

jest.mock(
  "@salesforce/apex/PortfolioHomeController.getShowcase",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);

describe("c-portfolio-home", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    jest.clearAllMocks();
  });

  async function flushPromises() {
    return Promise.resolve();
  }

  it("renders profile, stats and published projects", async () => {
    const element = createElement("c-portfolio-home", { is: PortfolioHome });
    document.body.appendChild(element);

    getShowcase.emit(mockShowcase);
    await flushPromises();

    expect(element.shadowRoot.querySelector(".name").textContent).toBe(
      "Rodrigo Moreira"
    );
    expect(element.shadowRoot.querySelectorAll(".stat-card")).toHaveLength(2);
    expect(element.shadowRoot.querySelector(".project-title").textContent).toBe(
      "Salesforce Portfolio App"
    );
  });
});
