#!/usr/bin/env fish

set -l test_root (command mktemp -d)
set -gx HOME "$test_root/home"
command mkdir -p -- "$HOME"
set -gx SDIRS "$HOME/.sdirs"
set -gx NO_FISHMARKS_COMPAT_ALIASES 1
set -g repo_root (path resolve -- (path dirname -- (status filename))/..)

source "$repo_root/marks.fish"

set -g failures 0
set -g assertions 0

function _assert_eq --argument-names expected actual message
    set -g assertions (math $assertions + 1)
    if test "$expected" != "$actual"
        set_color red
        printf 'FAIL: %s\n  expected: %s\n  actual:   %s\n' "$message" "$expected" "$actual"
        set_color normal
        set -g failures (math $failures + 1)
    end
end

function _assert_status --argument-names expected actual message
    _assert_eq "$expected" "$actual" "$message"
end

function _prepare_dir --argument-names dir_path
    command mkdir -p -- "$dir_path"
    cd -- "$dir_path"
end

function _test_save_and_print
    _prepare_dir "$HOME/work/app"
    save_bookmark app
    _assert_status 0 $status 'save_bookmark succeeds'

    set -l location (print_bookmark app)
    _assert_status 0 $status 'print_bookmark succeeds'
    _assert_eq "$HOME/work/app" "$location" 'print_bookmark returns saved path'
end

function _test_default_name_generation
    _prepare_dir "$HOME/work/my-app.v2"
    save_bookmark
    _assert_status 0 $status 'save_bookmark without name succeeds'

    set -l location (print_bookmark my_app_v2)
    _assert_status 0 $status 'default bookmark name is discoverable'
    _assert_eq "$HOME/work/my-app.v2" "$location" 'default bookmark name is sanitized basename'
end

function _test_go_to_and_delete
    _prepare_dir "$HOME/projects/alpha"
    save_bookmark alpha
    _assert_status 0 $status 'save alpha bookmark succeeds'

    _prepare_dir "$HOME/projects/other"
    go_to_bookmark alpha
    _assert_status 0 $status 'go_to_bookmark succeeds for existing entry'
    _assert_eq "$HOME/projects/alpha" "$PWD" 'go_to_bookmark changes current directory'

    delete_bookmark alpha
    _assert_status 0 $status 'delete_bookmark succeeds for existing entry'

    print_bookmark alpha >/dev/null 2>/dev/null
    _assert_status 1 $status 'deleted bookmark no longer resolves'
end

function _test_legacy_file_compatibility
    command mkdir -p -- "$HOME/legacy/location"
    printf 'export DIR_legacy="\\$HOME/legacy/location"\n' > "$SDIRS"
    printf 'export DIR_absolute="/tmp"\n' >> "$SDIRS"
    printf 'not a bookmark line\n' >> "$SDIRS"

    set -l legacy_value (print_bookmark legacy)
    _assert_status 0 $status 'legacy bookmark is parsed'
    _assert_eq "$HOME/legacy/location" "$legacy_value" 'legacy value expands $HOME safely'

    set -l absolute_value (print_bookmark absolute)
    _assert_status 0 $status 'absolute legacy bookmark is parsed'
    _assert_eq '/tmp' "$absolute_value" 'absolute path is preserved'
end

function _test_invalid_name_rejected
    _prepare_dir "$HOME/work/invalid"
    save_bookmark 'bad-name' >/dev/null 2>/dev/null
    _assert_status 1 $status 'invalid bookmark names are rejected'
end

function _test_conf_aliases
    set -e NO_FISHMARKS_COMPAT_ALIASES
    set -e __fishmarks_conf_loaded
    source "$repo_root/conf.d/fishmarks.fish"

    type -q s
    _assert_status 0 $status 'alias s is configured by conf.d script'
    type -q g
    _assert_status 0 $status 'alias g is configured by conf.d script'
    type -q p
    _assert_status 0 $status 'alias p is configured by conf.d script'
    type -q d
    _assert_status 0 $status 'alias d is configured by conf.d script'
    type -q l
    _assert_status 0 $status 'alias l is configured by conf.d script'
end

_test_save_and_print
_test_default_name_generation
_test_go_to_and_delete
_test_legacy_file_compatibility
_test_invalid_name_rejected
_test_conf_aliases

if test $failures -gt 0
    printf '\n%d of %d assertions failed\n' "$failures" "$assertions"
    exit 1
end

set_color green
printf 'All %d assertions passed\n' "$assertions"
set_color normal
