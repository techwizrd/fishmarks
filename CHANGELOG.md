# Changelog

All notable changes to this project are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Fish plugin packaging with `functions/`, `conf.d/`, and `completions/` layout.
- Automated test suite (`tests/run.fish`) and style/syntax checks (`tests/check.fish`).
- GitHub Actions CI workflow and pre-commit/prek hook configuration.
- Contributor policy docs and GitHub issue/PR templates.
- `fishmarks_version` command to report plugin version.

### Changed

- Core bookmark handling refactored to fish-native parsing and safer file processing.
- Installer updated for Fish 3+ and modern startup integration via `conf.d`.
- `save_bookmark` now rejects paths containing newline or carriage-return characters.
