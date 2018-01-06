# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added support for `:as` in `timestamp` properties
- `user_options` are now forwarded to expanded associations
- Made associations ORM-independent with the Adapter API
- Implemented the Type Overrides API

### Fixed

- Fixed `type` property not returning `list` for instances of `ActiveRecord::Relation`

## [2.0.0]

First Pragma 2 release.

[Unreleased]: https://github.com/pragmarb/pragma-decorator/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/pragmarb/pragma-decorator/compare/v1.2.0...v2.0.0