# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.2.6]

### Fixed

- Fixed an issue with association definition

## [2.2.5] (yanked)

### Fixed

- Fixed the expansion of associations with custom names requiring the original name to be used

## [2.2.4]

### Fixed

- Fixed an issue where expanding a property would expand properties with the same name in associated 
  objects

## [2.2.3]

### Fixed

- Fixed an issue with the loading of polymorphic associations

## [2.2.2]

### Fixed

- Fixed an issue causing the PORO adapter to be loaded for all models

## [2.2.1]

### Changed

- Use [Adaptor](https://github.com/aldesantis/adaptor.rb) for association and pagination adpators

## [2.2.0]

### Added

- Added support for custom pagination adapters
- Implemented STI support in `Collection`

### Changed

- Renamed `Pagination#adapter` to `#pagination_adapter`
- `Type` now replaces `::` with `/`

### Fixed

- Fixed AR association adapter not working with custom scopes
- Fixed AR association adapter not working with `has_one`
- Fixed associations inheritance
- Fixed association expansion for non-AR associations defined on AR models

## [2.1.1]

### Fixed

- Fixed ActiveRecord association adapter

## [2.1.0]

### Added

- Added support for `:as` in `timestamp` properties
- `user_options` are now forwarded to expanded associations
- Made associations ORM-independent with the Adapter API
- Implemented the Type Overrides API
- Implemented the Pagination Adapter API

### Changed

- Changed the `#type` of collections from `collection` to `list`
- Replaced `feature` with `include` in tests and examples

### Fixed

- Fixed `type` property not returning `list` for instances of `ActiveRecord::Relation`
- Fixed bugs with the optimization of associations with custom scopes
 
## [2.0.0]

First Pragma 2 release.

[Unreleased]: https://github.com/pragmarb/pragma-decorator/compare/v2.2.6...HEAD
[2.2.6]: https://github.com/pragmarb/pragma-decorator/compare/v2.2.5...v2.2.6
[2.2.5]: https://github.com/pragmarb/pragma-decorator/compare/v2.2.4...v2.2.5
[2.2.4]: https://github.com/pragmarb/pragma-decorator/compare/v2.2.3...v2.2.4
[2.2.3]: https://github.com/pragmarb/pragma-decorator/compare/v2.2.2...v2.2.3
[2.2.2]: https://github.com/pragmarb/pragma-decorator/compare/v2.2.1...v2.2.2
[2.2.1]: https://github.com/pragmarb/pragma-decorator/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/pragmarb/pragma-decorator/compare/v2.1.1...v2.2.0
[2.1.1]: https://github.com/pragmarb/pragma-decorator/compare/v2.1.0...v2.1.1
[2.1.0]: https://github.com/pragmarb/pragma-decorator/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/pragmarb/pragma-decorator/compare/v1.2.0...v2.0.0
