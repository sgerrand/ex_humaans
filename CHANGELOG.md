# Changelog

All notable changes to this project will be documented in this file. See [Keep a
CHANGELOG](http://keepachangelog.com/) for how to update this file. This project
adheres to [Semantic Versioning](http://semver.org/).

<!-- %% CHANGELOG_ENTRIES %% -->

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
