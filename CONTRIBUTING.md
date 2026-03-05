# Contributing to fishmarks

Thanks for contributing.

## Development setup

1. Fork and clone the repository.
2. Create a feature branch from `master`.
3. Install Fish 3+.
4. Install local hooks:

```fish
prek install
```

## Validate changes locally

Run checks before committing:

```fish
fish tests/check.fish
fish tests/run.fish
```

Or run all hooks:

```fish
prek run --all-files
```

## Pull requests

- Keep PRs focused and small when possible.
- Include tests for behavior changes.
- Update docs when usage or setup changes.
- Use clear commit messages that explain why the change is needed.

## Compatibility policy

- The project targets Fish 3+.
- Backward compatibility with existing bookmark storage (`~/.sdirs`) should be preserved unless a migration path is documented.

## Versioning and changelog

- Releases follow Semantic Versioning.
- User-visible changes should be added to `CHANGELOG.md` under `Unreleased`.
