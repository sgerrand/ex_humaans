# Changelog

All notable changes to this project will be documented in this file. See [Keep a
CHANGELOG](http://keepachangelog.com/) for how to update this file. This project
adheres to [Semantic Versioning](http://semver.org/).

<!-- %% CHANGELOG_ENTRIES %% -->

## [0.5.1](https://github.com/sgerrand/ex_humaans/compare/v0.5.0...v0.5.1) (2026-04-22)


### Bug Fixes

* **deps:** update telemetry from 1.3.0 to 1.4.1, credo to 1.7.18 ([#83](https://github.com/sgerrand/ex_humaans/issues/83)) ([0184955](https://github.com/sgerrand/ex_humaans/commit/0184955efd531a783e81821f420cc08af9e9eb3c))

## [0.5.0](https://github.com/sgerrand/ex_humaans/compare/v0.4.2...v0.5.0) (2026-04-15)


### Features

* add Humaans.Pagination for page-by-page and streaming iteration ([#77](https://github.com/sgerrand/ex_humaans/issues/77)) ([36b8955](https://github.com/sgerrand/ex_humaans/commit/36b8955459866382c295c6be44faeadfbfb9e7d9))
* add telemetry instrumentation for API requests ([#75](https://github.com/sgerrand/ex_humaans/issues/75)) ([048be7d](https://github.com/sgerrand/ex_humaans/commit/048be7d40341de2fee8a8f3f00f3820bf91f1ff9))
* introduce Humaans.Error for structured error handling ([#72](https://github.com/sgerrand/ex_humaans/issues/72)) ([a60d780](https://github.com/sgerrand/ex_humaans/commit/a60d7805fa446366d0314d440bf94717a99d4674))
* parse ISO 8601 date and datetime strings into native Elixir types ([#74](https://github.com/sgerrand/ex_humaans/issues/74)) ([f3b461e](https://github.com/sgerrand/ex_humaans/commit/f3b461e37e46b204a97f50b4dbea9061cf501128))

## [0.4.2](https://github.com/sgerrand/ex_humaans/compare/v0.4.1...v0.4.2) (2026-04-14)


### Bug Fixes

* **ci:** Disable credo check on API response struct ([#56](https://github.com/sgerrand/ex_humaans/issues/56)) ([85c1c76](https://github.com/sgerrand/ex_humaans/commit/85c1c76bc9ee69313c65668761fb200e0d49203c))

## 0.4.1 - 2025-04-25

### Changes
-Fixed incorrect encoding of request body for HTTP patch, post and put methods.


## 0.4.0 - 2025-03-11

### Changed
- Configurable HTTP client module
- Updated and improved package and module documentation


## 0.3.1 - 2025-03-04

### Changed
- Fixed existing release notes
- Updated package release workflow


## 0.3.0 - 2025-03-04

### Changes

- Introduce `ResponseHandler` to centrally manage how API responses are handled.


## 0.2.2 - 2025-03-04

### Enhancements

- Improved ExDoc configuration for HexDocs
- Added changelog to package metadata for Hex.pm


## 0.2.1 - 2025-03-04

### Changed

- Provide default implementation for Humaans.Client.

## 0.2.0 - 2025-03-03

### Changed

- **Breaking change**: Switched to a client-based approach instead of global configuration
- Added convenience accessor functions for resource modules

### Usage changes

Instead of using global configuration:
```elixir
{:ok, people} = Humaans.People.list()
```

Now use the client-based approach:
```elixir
client = Humaans.new(access_token: "YOUR_ACCESS_TOKEN")
{:ok, people} = Humaans.People.list(client)
```

## 0.1.0 - 2025-02-26

Initial release. :rocket:
