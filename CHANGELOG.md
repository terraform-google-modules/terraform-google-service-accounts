# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.0.0](https://github.com/terraform-google-modules/terraform-google-service-accounts/compare/terraform-google-service-accounts-v4.0.3...terraform-google-service-accounts-v5.0.0) (2022-01-04)


### ⚠ BREAKING CHANGES

* Restrict to Terraform 0.13+ and add module attribution (#38)
* Service accounts were changed to use for_each, causing a state migration. See the [upgrade guide](./docs/upgrading_to_v2.0.md) for details.

### Features

* Add support for custom display_name and description [#18](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/18) ([#19](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/19)) ([badaaf3](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/badaaf3639aef1e0256b69d8f017693c5737733f))
* Added Service Account key distributor submodule ([#32](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/32)) ([fb794a5](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/fb794a5a78495973b83bc3162fe1c497058c7647))
* Enable overriding descriptions for individual service accounts ([#41](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/41)) ([9abb768](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/9abb7685d8070d2b54f5f8775a2041faed4de666))
* Restrict to Terraform 0.13+ and add module attribution ([#38](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/38)) ([c423601](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/c42360190ad4fbac2466ed77db469e2f2b4e60b1))
* update TPG version constraints to allow 4.0 ([#54](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/54)) ([36a2f59](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/36a2f592823e9feffb1475695fa8a686b1626452))
* Use for_each instead of count to create resource ([#15](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/15)) ([19c8a02](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/19c8a02361af89aa7f3036c843f1cf9f39866d1e))


### Bug Fixes

* declare "key" output as sensitive value ([#47](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/47)) ([31304f2](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/31304f2bc30bc29e53d798de067ee543cba237b9))
* Key should be the actual value of the generated json content ([#26](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/26)) ([b6f3452](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/b6f345279519ab8eac300c47af8d60b9e6a5a5e8))
* properly apply all bindings to all service accounts ([cbab563](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/cbab56328b86d6b438ce29d18d76aff26868e8df))
* remove extraneous dollar sign in `keys` output ([#50](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/50)) ([711e1db](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/711e1dbc6f15d463cf831bea7bad80b4b07b3fcd))
* Remove outdated template provider ([#43](https://github.com/terraform-google-modules/terraform-google-service-accounts/issues/43)) ([92cac5b](https://github.com/terraform-google-modules/terraform-google-service-accounts/commit/92cac5bf7908e2ee8a44d4d86b6e31548c1f60f3))

### [4.0.3](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/compare/v4.0.2...v4.0.3) (2021-09-01)


### Bug Fixes

* remove extraneous dollar sign in `keys` output ([#50](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/50)) ([711e1db](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/711e1dbc6f15d463cf831bea7bad80b4b07b3fcd))

### [4.0.2](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/compare/v4.0.1...v4.0.2) (2021-06-30)


### Bug Fixes

* declare "key" output as sensitive value ([#47](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/47)) ([31304f2](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/31304f2bc30bc29e53d798de067ee543cba237b9))

### [4.0.1](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/compare/v4.0.0...v4.0.1) (2021-06-04)


### Bug Fixes

* Remove outdated template provider ([#43](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/43)) ([92cac5b](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/92cac5bf7908e2ee8a44d4d86b6e31548c1f60f3))

## [4.0.0](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/compare/v3.0.1...v4.0.0) (2021-03-16)


### ⚠ BREAKING CHANGES

* Restrict to Terraform 0.13+ and add module attribution (#38)

### Features

* Added Service Account key distributor submodule ([#32](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/32)) ([fb794a5](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/fb794a5a78495973b83bc3162fe1c497058c7647))
* Enable overriding descriptions for individual service accounts ([#41](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/41)) ([9abb768](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/9abb7685d8070d2b54f5f8775a2041faed4de666))
* Restrict to Terraform 0.13+ and add module attribution ([#38](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/38)) ([c423601](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/c42360190ad4fbac2466ed77db469e2f2b4e60b1))

### [3.0.1](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/compare/v3.0.0...v3.0.1) (2020-07-21)


### Bug Fixes

* Key should be the actual value of the generated json content ([#26](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/26)) ([b6f3452](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/b6f345279519ab8eac300c47af8d60b9e6a5a5e8))

### [3.0.1](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/compare/v3.0.0...v3.0.1) (2020-07-21)


### Bug Fixes

* Key should be the actual value of the generated json content ([#26](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/26)) ([b6f3452](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/b6f345279519ab8eac300c47af8d60b9e6a5a5e8))

## [3.0.0](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/compare/v2.0.2...v3.0.0) (2020-05-15)


### ⚠ BREAKING CHANGES

* Service accounts were changed to use for_each, causing a state migration. See the [upgrade guide](./docs/upgrading_to_v3.md) for details.

### Features

* Add support for custom display_name and description [#18](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/18) ([#19](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/19)) ([badaaf3](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/badaaf3639aef1e0256b69d8f017693c5737733f))
* Use for_each instead of count to create resource ([#15](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/issues/15)) ([19c8a02](https://www.github.com/terraform-google-modules/terraform-google-service-accounts/commit/19c8a02361af89aa7f3036c843f1cf9f39866d1e))

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
