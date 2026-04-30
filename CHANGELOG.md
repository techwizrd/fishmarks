# Changelog

All notable changes to this project are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2026-04-30

### Added

- Fish plugin packaging with `functions/`, `conf.d/`, and `completions/` layout.
- Automated test suite (`tests/run.fish`) and style/syntax checks (`tests/check.fish`).
- GitHub Actions CI workflow and pre-commit/prek hook configuration.
- Contributor policy docs and GitHub issue/PR templates.
- `fishmarks_version` command to report plugin version.
- Fundle compatibility via root `init.fish` and a CI smoke test.
- README troubleshooting guidance for `fishmarks_version` and `fishmarks_doctor`.
- `list_bookmarks --missing` for finding bookmarks whose directories no longer exist.
- `fishmarks_doctor --fix` and `--yes` for safe cleanup of malformed and duplicate entries.

### Changed

- Core bookmark handling refactored to fish-native parsing and safer file processing.
- Installer updated for Fish 3+ and modern startup integration via `conf.d`.
- `install.fish` now detects current Fish versions correctly during install-time version checks.
- `save_bookmark` now rejects paths containing newline or carriage-return characters.
- `fishmarks_version` now reports the current released plugin version.
