# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/compare/v2.0.2...v3.0.0) (2020-05-15)


### ⚠ BREAKING CHANGES

* Service accounts were changed to use for_each, causing a state migration. See the [upgrade guide](./docs/upgrading_to_v2.0.md) for details.

### Features

* Add support for custom display_name and description [#18](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/18) ([#19](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/19)) ([badaaf3](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/badaaf3639aef1e0256b69d8f017693c5737733f))
* Use for_each instead of count to create resource ([#15](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/15)) ([19c8a02](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/19c8a02361af89aa7f3036c843f1cf9f39866d1e))

## [Unreleased]

### Added

- Support for `display_name` and `description` [#18]
- Use `for_each` instead of `count` [#15]

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

[#15]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/15
[#14]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/14
[#13]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/13
[#9]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/9
[#3]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/3
[#1]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/1
[#6]: https://github.com/terraform-google-modules/terraform-google-service-accounts/pull/6
