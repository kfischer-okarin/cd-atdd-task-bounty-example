# Continuous Delivery Rails Example

This repository demonstrates a possible implementation of a simple Deployment
Pipeline (as proposed by Dave Farley) in a Rails project implemented using
GitHub Actions.

## Deployment Pipeline

The deployment pipeline consists of three main stages:

1. **Commit Stage**: ([`commit-stage.yml`](.github/workflows/commit-stage.yml))
   This stage runs on every pull request and push. It includes jobs for scanning
   Ruby and JavaScript code for security vulnerabilities, linting the code for
   consistent style, and running unit tests.

2. **Create Artifact**: ([`create-artifact.yml`](.github/workflows/create-artifact.yml))
   This stage runs after the successful completion of the Commit Stage on the
   main branch. It builds a Docker image as artifact, tags it with the current
   commit SHA and pushes it to Docker Hub.

3. **Acceptance Stage**: ([`acceptance-stage.yml`](.github/workflows/acceptance-stage.yml))
   This stage runs after the successful completion of the Create Artifact stage.
   It starts a Docker container from the built image and runs acceptance tests
   against it.
