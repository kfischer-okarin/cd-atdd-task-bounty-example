# Continuous Delivery Rails Example
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

This repository demonstrates a possible implementation of a simple Deployment
Pipeline (as proposed by Dave Farley) in a Rails project implemented using
GitHub Actions.

> [!CAUTION]
> This example is not fit for production use as-is.
> Check the [Things out of Scope](#things-out-of-scope) section for details.

## Table of Contents
- [Implemented Techniques](#implemented-techniques)
  - [Deployment Pipeline](#deployment-pipeline)
    - [1. Commit Stage](#1-commit-stage)
    - [2. Create Artifact](#2-create-artifact)
    - [3. Acceptance Stage](#3-acceptance-stage)
  - [4 Layer Acceptance Test Architecture](#4-layer-acceptance-test-architecture)
    - [1. Test Cases](#1-test-cases)
    - [2. DSL (Domain-Specific Language)](#2-dsl-domain-specific-language)
    - [3. Protocol Driver](#3-protocol-driver)
    - [4. System Under Test](#4-system-under-test)
- [References for further Study](#references-for-further-study)
- [Things out of Scope](#things-out-of-scope)

## Implemented Techniques
### Deployment Pipeline
The deployment pipeline consists of three main stages:

#### 1. Commit Stage
This stage runs on every pull request and push. It includes jobs for scanning
Ruby and JavaScript code for security vulnerabilities, linting the code for
consistent style, and running unit tests.

**Implementation:** [`.github/workflows/commit-stage.yml`](.github/workflows/commit-stage.yml)

#### 2. Create Artifact
This stage runs after the successful completion of the Commit Stage on the `main`
branch. It builds a Docker image as artifact, tags it with the current commit
SHA and pushes it to Docker Hub.

**Implementation:** [`.github/workflows/create-artifact.yml`](.github/workflows/create-artifact.yml)

#### 3. Acceptance Stage
This stage runs after the successful completion of the Create Artifact stage. It
starts a Docker container from the built image and runs acceptance tests against
it.

**Implementation:** [`.github/workflows/acceptance-stage.yml`](.github/workflows/acceptance-stage.yml)


### 4 Layer Acceptance Test Architecture
The acceptance tests are written using the 4 Layer Acceptance Test
Architecture (also proposed by Dave Farley).

#### 1. Test Cases
This layer contains the actual test cases that define the acceptance criteria.
The test cases are written solely using the DSL layer.

**Implementation:** [`test/system/`](test/system/) directory

#### 2. DSL (Domain-Specific Language)
This layer provides a high-level language to describe actions and assertions
from a business perspective, typically from the point of view of an end user.
It is recommended to avoid mentioning technical details or UI elements,
focusing instead on *what* is happening or being done in business domain terms.

Responsibilities of the DSL layer include:
- Providing an easy-to-use and readable API for authoring test cases.
- Offering sensible default parameter values, allowing test cases to be written
  without specifying details irrelevant to the scenario.
- Mapping identifiers to unique aliases before passing them to the driver or
  performing assertions. This enables test cases to execute in parallel
  against the same environment without interfering with each other.

**Implementation:** [`test/support/acceptance_test_dsl.rb`](test/support/acceptance_test_dsl.rb) included inside [`test/application_system_test_case.rb`](test/application_system_test_case.rb)

#### 3. Protocol Driver
This layer interacts with the system under test using a specific protocol
(commonly through the UI or a web API). It translates high-level commands from
the DSL into low-level operations, handling *how* business actions are executed
within your system.

If your system offers multiple methods of interaction, you would implement a
separate driver for each one, ensuring that the DSL remains agnostic to the
underlying protocol.

**Implementation:** [`test/support/capybara_acceptance_test_driver.rb`](test/support/capybara_acceptance_test_driver.rb)

#### 4. System Under Test
This is the actual application or system being tested. When executing
acceptance tests, it is crucial to have an environment that closely mirrors a
real production environment to accurately assess whether the application
currently fulfills all its business requirements.

At the same time, it is equally important to control external variables, such
as system time or responses from external systems that are beyond your control,
to ensure deterministic test results. Controlling time, for example, is
essential for testing time-dependent functionality, as such tests would be
impossible to conduct reliably otherwise.

To achieve this, the system must be designed to allow the injection and
replacement of such dependencies through configuration, enabling seamless
substitution of such external factors.


## References for further Study
- [Acceptance Testing Webinar (YouTube)](https://www.youtube.com/watch?v=SuDIYk9GBpE)
- [Continuous Delivery Webinar (YouTube)](https://www.youtube.com/watch?v=ONnwToAH4bU)


## Things out of Scope
Following things are whole sub-areas which would have added a lot of incidental
complexity to this sample and have been left out and/or simplified on purpose.

### Deployment
Currently, "deploying the application" means just starting a local Docker
container (see
[`./bin/deploy-to-acceptance-test-environment`](bin/deploy-to-acceptance-test-environment)
used in the acceptance stage for details).

I also removed the default Kamal settings generated by Rails from this project
to not give the impression that this project could be deployed anywhere as it
is.

Since the Application is not actually deployable - the deployment pipeline just
finishes after the acceptance stage and does not push the changes to the
production environment as would be common with a real Continuous Delivery
workflow.

### SSL
I added support for a environment variable to completely disable SSL in
production and enabled it in the acceptance stage.

### User Management & Authentication
The application itself has a concept of users but for simplicity's sake there
is neither user management (new users are added via a public `/users/new` page)
nor any kind of authentication (users just login via their user name).

### Beautiful Page Design :wink:
This app's page design is powered by ChatGPT and the [Bulma](https://bulma.io/)
CSS framework.
