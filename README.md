# Self-Hosted Sentry

[Sentry](https://sentry.io/), feature-complete and packaged up for low-volume deployments and proofs-of-concept.

Documentation on the Self-Hosted Sentry project [here](https://develop.sentry.dev/self-hosted/).

## Folio's fork

Folio's use case falls in the "low-volume deployments" category mentioned above.

We run Self-Hosted Sentry from the `folio` branch of this fork on a dedicated virtual machine in Google Cloud.

Folio's fork of the Self-Hosted Sentry project deviates slightly from the "official" Self-Hosted Sentry:

| What                          | Default                                          | Folio                                                                       |
|-------------------------------|--------------------------------------------------|-----------------------------------------------------------------------------|
| Postgres                      | Run Postgres as part of the Docker Compose stack | Use a Cloud SQL instance (and configure the connection via the environment) |
| Sentry secret key             | No idea what they actually want us to do         | Configure via the environment                                               |
| Sentry URL prefix             | No idea what they actually want us to do         | Configure via the environment                                               |
| Google SSO                    | Configure manually (in the Sentry UI)            | Configure via the environment                                               |
| Slack integration             | Configure manually (in the Sentry UI)            | Configure via the environment                                               |
| GitHub integration            | Configure manually (in the Sentry UI)            | Configure via the environment                                               |
| Send automatic reports Sentry | Yes                                              | No (configured by setting `REPORT_SELF_HOSTED_ISSUES="0"`)                  |

### Upgrade

Sentry [uses "calendar versioning"](https://develop.sentry.dev/self-hosted/releases/), so they release:

- One `minor` version on (or just after) the 15th of every month (for example, the November 2024 primary release is
  tagged `24.11.0`)
- (As needed) `patch` versions to fix any issues in the previous version (for example, the first November 2024 patch
  release is tagged `24.11.1`)

The Slack channel [#sentry-releases](https://folio-as.slack.com/archives/C07MLCV9546) is subscribed to new Self-Hosted
Sentry releases. Join it so you don't have to remember to check for new releases.

#### If we are several versions behind

If we have to upgrade through several versions, remember to check if there are any
relevant [hard stop versions](https://develop.sentry.dev/self-hosted/releases/#hard-stops) that we cannot skip.

#### Upgrade to a new primary release (like `24.11.0`)

When a new version of Self-Hosted Sentry is released, we can upgrade to it as follows.

(Using the November 2024 primary release (`24.11.0`) as an example)

1. `$ git checkout folio` (be on the Folio branch)
2. `$ git pull` (pull any changes on the `folio` branch, and fetch the new tag)
3. `$ git merge 24.11.0` (merge the new version into the `folio` branch)
4. (Resolve any merge conflicts, keeping this fork's intended deviations from the main branch in mind)
5. `$ git commit` (commit the merge)
6. `$ git tag 24.11.0-folio` (tag the merge commit as `${SENTRY_VERSION}-folio`)
7. `$ git push` (push the merge commit)
8. `$ git push --tags` (push the tag)
9. Head over to the `infra` repo and
   follow [the steps to deploy a new version](https://github.com/folio-as/infra/tree/master/pulumi/sentry).
