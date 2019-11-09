# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.2] - 2019-10-09

### Fixed

- Fix outputs on `names` variable element removal/change [#14]

## [2.0.1] - 2019-09-13

### Changed

- Fix example in top-level README to work with terraform-0.12.x [#13]

## [2.0.0] - 2019-08-14

### Changed

- Refactored outputs and list generation. [#9]
  - Added new `service_account` and `service_accounts` outputs for single and multi user use that expose the base resources, now possible with Terraform 0.12.
  - Added new `emails_list` and `iam_emails_list` outputs that return lists, and are guaranteed to keep the same ordering for resources as the map type outputs.
  - Refactored the formatted list generation for the `iam_emails` and new `iam_emails_list` outputs to use the new `for` expression, fixing   issues with `formatlist` and `zipmap` in Terraform 0.12.
  - Refactored and simplified the `keys` template and output using the new splat syntax.
  - **BREAKING**: Changed the keys for the `keys` output to use the Service Account name.

## [1.0.0] - 2019-07-26

### Changed

- Upgraded for usage with terraform-0.12.x [#6]

## [0.1.1] - 2019-06-14

### Fixed

- All bindings are applied to all service accounts. [#3]

## [0.1.0] - 2019-05-28

### Added

- Initial release. [#1]

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-service-accounts/compare/v2.0.2...HEAD
[2.0.2]: https://github.com/terraform-google-modules/terraform-google-service-accounts/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/terraform-google-modules/terraform-google-service-accounts/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/terraform-google-modules/terraform-google-service-accounts/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-service-accounts/compare/v0.1.1...v1.0.0
[0.1.1]: https://github.com/terraform-google-modules/terraform-google-service-accounts/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/terraform-google-modules/terraform-google-service-accounts/releases/tag/v0.1.0

[#14]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/14
[#13]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/13
[#9]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/9
[#3]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/3
[#1]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/1
[#6]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/6
