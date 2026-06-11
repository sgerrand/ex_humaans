# Changelog

All notable changes to this project will be documented in this file. See [Keep a
CHANGELOG](http://keepachangelog.com/) for how to update this file. This project
adheres to [Semantic Versioning](http://semver.org/).

<!-- %% CHANGELOG_ENTRIES %% -->

## [0.6.0](https://github.com/sgerrand/ex_humaans/compare/v0.5.1...v0.6.0) (2026-06-11)


### Features

* **audit-roles-tasks:** add read-only resources (Audit Events, Roles, Tasks, OKRs, Webhook Events) ([#107](https://github.com/sgerrand/ex_humaans/issues/107)) ([f49fe3e](https://github.com/sgerrand/ex_humaans/commit/f49fe3ef9d017bc108d8ecebe0fd3fa26d9f0dcd))
* **client:** convert snake_case body keys to camelCase ([#94](https://github.com/sgerrand/ex_humaans/issues/94)) ([ac6b555](https://github.com/sgerrand/ex_humaans/commit/ac6b55594078b21b4c738245355f9b700aa9abfc))
* **companies:** add retrieve/2, deprecate get/2 ([#99](https://github.com/sgerrand/ex_humaans/issues/99)) ([f50bed4](https://github.com/sgerrand/ex_humaans/commit/f50bed403f48248b4b1f0967180cc597919f3a6a))
* **custom-fields:** add Custom Fields and Custom Values CRUD ([#101](https://github.com/sgerrand/ex_humaans/issues/101)) ([6ed53f1](https://github.com/sgerrand/ex_humaans/commit/6ed53f18c199b49ff4e2e58cc567783823003da3))
* **documents:** add Documents, Document Types, and Document Folders ([#102](https://github.com/sgerrand/ex_humaans/issues/102)) ([0b284b9](https://github.com/sgerrand/ex_humaans/commit/0b284b9c1453dcc9135af201266b1df2771f5c6f))
* **error:** extract structured Humaans API error fields ([#88](https://github.com/sgerrand/ex_humaans/issues/88)) ([dfeb97a](https://github.com/sgerrand/ex_humaans/commit/dfeb97a59a57b3d937d702adda5627b3d4954007))
* **esign:** add Esign family read-only resources ([#113](https://github.com/sgerrand/ex_humaans/issues/113)) ([6fa3e2e](https://github.com/sgerrand/ex_humaans/commit/6fa3e2e25135b04a165f81a06cb12fe9643409ff))
* **http_client:** pass-through req_options on Humaans.new/1 ([#89](https://github.com/sgerrand/ex_humaans/issues/89)) ([48f9c59](https://github.com/sgerrand/ex_humaans/commit/48f9c594b1143606814af1ca08b8268e32d79797))
* **http_client:** retry transient failures with bounded backoff ([#90](https://github.com/sgerrand/ex_humaans/issues/90)) ([158d960](https://github.com/sgerrand/ex_humaans/commit/158d9609fe55ef3cebe5c4061bb96029166c285a))
* **me, token_info:** add singleton helpers for /me and /token-info ([#96](https://github.com/sgerrand/ex_humaans/issues/96)) ([89dea03](https://github.com/sgerrand/ex_humaans/commit/89dea038c310adf916f630cdf552cce3b35ac6b3))
* **org-structure:** add Job Roles, Locations, and Spaces ([#103](https://github.com/sgerrand/ex_humaans/issues/103)) ([50140e4](https://github.com/sgerrand/ex_humaans/commit/50140e4fb69090080a669f58bc05b705ae0411f9))
* **performance:** add Performance family read-only resources ([#108](https://github.com/sgerrand/ex_humaans/issues/108)) ([cb4b1cd](https://github.com/sgerrand/ex_humaans/commit/cb4b1cd7cc15af8e39d5a0e1cf0854f6a4156d95))
* **profile-family:** add D2 employee profile resources ([#106](https://github.com/sgerrand/ex_humaans/issues/106)) ([7c3324b](https://github.com/sgerrand/ex_humaans/commit/7c3324b680c654dfc93ad50fdba7b219b369cb48))
* **query:** add chainable filter query builder ([#93](https://github.com/sgerrand/ex_humaans/issues/93)) ([3b25f52](https://github.com/sgerrand/ex_humaans/commit/3b25f52dfb1a78f2265e15dafff0f2945f6c5e9f))
* **requests-workflow:** add Requests and Workflow family read-only resources ([#112](https://github.com/sgerrand/ex_humaans/issues/112)) ([69acd3e](https://github.com/sgerrand/ex_humaans/commit/69acd3e0c6095957d57b10282c5d1497f09987a9))
* **time-away:** add Time Away family CRUD resources ([#100](https://github.com/sgerrand/ex_humaans/issues/100)) ([ce059f2](https://github.com/sgerrand/ex_humaans/commit/ce059f2d372deaa194b4bae58042463c0fed558b))
* **webhooks:** add HMAC-SHA256 signature verification helper ([#92](https://github.com/sgerrand/ex_humaans/issues/92)) ([9cd0c7e](https://github.com/sgerrand/ex_humaans/commit/9cd0c7ec619397a68fa4cb708f1361478decab01))
* **webhooks:** add Webhooks CRUD ([#105](https://github.com/sgerrand/ex_humaans/issues/105)) ([6d26a0f](https://github.com/sgerrand/ex_humaans/commit/6d26a0fed19771e59c61ebca7bc507324f7cbd04))
* **working-patterns:** add Working Patterns and Allocations CRUD ([#104](https://github.com/sgerrand/ex_humaans/issues/104)) ([1d91eda](https://github.com/sgerrand/ex_humaans/commit/1d91eda92ca4669ae792d5ca304ec1ccf9309d10))


### Bug Fixes

* **deps:** bump req from 0.5.17 to 0.5.18 ([#114](https://github.com/sgerrand/ex_humaans/issues/114)) ([265ae46](https://github.com/sgerrand/ex_humaans/commit/265ae4653ce4c982da4c6c1c16133d53a4fc65f6))
* **pagination:** use $-prefixed limit/skip params ([#86](https://github.com/sgerrand/ex_humaans/issues/86)) ([cb6f868](https://github.com/sgerrand/ex_humaans/commit/cb6f8682ceafb6628019ed71e00e48a20eb060dc))


### Performance Improvements

* **pagination:** default page size to 100 ([#87](https://github.com/sgerrand/ex_humaans/issues/87)) ([2dfb053](https://github.com/sgerrand/ex_humaans/commit/2dfb05357e9bfabf8867d1eb4f9ff33219a77810))

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
