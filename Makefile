.PHONY: check test

check:
	fish tests/check.fish

test: check
	fish tests/run.fish
