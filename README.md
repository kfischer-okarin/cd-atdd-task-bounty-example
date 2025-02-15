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

## 4 Layer Acceptance Test Architecture
The acceptance tests are written using the 4 Layer Acceptance Test
Architecture (also proposed by Dave Farley).

### 1. Test Cases
This layer contains the actual test cases that define the acceptance criteria.
The test cases are written solely using the DSL layer.

**Implementation:** [`test/system/`](test/system/) directory

### 2. DSL (Domain-Specific Language)
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

### 3. Protocol Driver
This layer interacts with the system under test using a specific protocol
(commonly through the UI or a web API). It translates high-level commands from
the DSL into low-level operations, handling *how* business actions are executed
within your system.

If your system offers multiple methods of interaction, you would implement a
separate driver for each one, ensuring that the DSL remains agnostic to the
underlying protocol.

**Implementation:** [`test/support/capybara_acceptance_test_driver.rb`](test/support/capybara_acceptance_test_driver.rb)


### 4. System Under Test
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
