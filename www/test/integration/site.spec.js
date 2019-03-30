// / <reference types="Cypress" />

// Hack to avoid basic auth on Electron browser startup:
// https://github.com/cypress-io/cypress/issues/1639
const url = Cypress.env('baseUrlHack');

describe('Site', () => {
  beforeEach(() => {});

  it('Shows the site', () => {
    cy.visit(`${url}/`);
  });
});
