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

function _assert_true --argument-names status_value message
    _assert_status 0 "$status_value" "$message"
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

function _test_save_requires_force_to_overwrite
    _prepare_dir "$HOME/work/overwrite-one"
    save_bookmark overwrite_target
    _assert_status 0 $status 'first save for overwrite_target succeeds'

    _prepare_dir "$HOME/work/overwrite-two"
    save_bookmark overwrite_target >/dev/null 2>/dev/null
    _assert_status 1 $status 'save_bookmark rejects overwrite without --force'

    set -l location (print_bookmark overwrite_target)
    _assert_status 0 $status 'existing bookmark remains after rejected overwrite'
    _assert_eq "$HOME/work/overwrite-one" "$location" 'rejected overwrite keeps original path'

    save_bookmark --force overwrite_target
    _assert_status 0 $status 'save_bookmark --force overwrites existing bookmark'

    set -l updated_location (print_bookmark overwrite_target)
    _assert_status 0 $status 'forced overwrite is readable'
    _assert_eq "$HOME/work/overwrite-two" "$updated_location" 'forced overwrite updates bookmark path'
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

function _test_rename_bookmark
    _prepare_dir "$HOME/projects/rename-path"
    save_bookmark rename_old
    _assert_status 0 $status 'save bookmark for rename succeeds'

    rename_bookmark rename_old rename_new
    _assert_status 0 $status 'rename_bookmark succeeds'

    print_bookmark rename_old >/dev/null 2>/dev/null
    _assert_status 1 $status 'old bookmark name is removed after rename'

    set -l new_location (print_bookmark rename_new)
    _assert_status 0 $status 'new bookmark name resolves after rename'
    _assert_eq "$HOME/projects/rename-path" "$new_location" 'rename_bookmark preserves original path'
end

function _test_bookmark_exists
    _prepare_dir "$HOME/projects/exists-path"
    save_bookmark exists_target
    _assert_status 0 $status 'save bookmark for exists test succeeds'

    set -l existing_output (bookmark_exists exists_target)
    _assert_status 0 $status 'bookmark_exists returns success for existing bookmark'
    _assert_eq '' "$existing_output" 'bookmark_exists does not print output for existing bookmark'

    set -l missing_output (bookmark_exists missing_target)
    _assert_status 1 $status 'bookmark_exists returns failure for missing bookmark'
    _assert_eq '' "$missing_output" 'bookmark_exists does not print output for missing bookmark'
end

function _test_legacy_file_compatibility
    command mkdir -p -- "$HOME/legacy/location"
    printf 'export DIR_legacy="\\$HOME/legacy/location"\n' >"$SDIRS"
    printf 'export DIR_absolute="/tmp"\n' >>"$SDIRS"
    printf 'not a bookmark line\n' >>"$SDIRS"

    set -l legacy_value (print_bookmark legacy)
    _assert_status 0 $status 'legacy bookmark is parsed'
    _assert_eq "$HOME/legacy/location" "$legacy_value" 'legacy value expands $HOME safely'

    set -l absolute_value (print_bookmark absolute)
    _assert_status 0 $status 'absolute legacy bookmark is parsed'
    _assert_eq /tmp "$absolute_value" 'absolute path is preserved'
end

function _test_invalid_name_rejected
    _prepare_dir "$HOME/work/invalid"
    save_bookmark bad-name >/dev/null 2>/dev/null
    _assert_status 1 $status 'invalid bookmark names are rejected'
end

function _test_list_names_only
    _prepare_dir "$HOME/work/names-one"
    save_bookmark names_only_a
    _assert_status 0 $status 'save first names-only bookmark succeeds'

    _prepare_dir "$HOME/work/names-two"
    save_bookmark names_only_b
    _assert_status 0 $status 'save second names-only bookmark succeeds'

    set -l names_output (list_bookmarks --names-only)
    _assert_status 0 $status 'list_bookmarks --names-only succeeds'

    contains -- names_only_a $names_output
    _assert_true $status 'names-only output includes first bookmark name'

    contains -- names_only_b $names_output
    _assert_true $status 'names-only output includes second bookmark name'

    string match -q '*/*' -- "$names_output"
    _assert_status 1 $status 'names-only output does not include paths'
end

function _test_argument_validation
    print_bookmark one two >/dev/null 2>/dev/null
    _assert_status 1 $status 'print_bookmark rejects extra arguments'

    print_bookmark --unknown >/dev/null 2>/dev/null
    _assert_status 1 $status 'print_bookmark rejects unknown options'

    go_to_bookmark one two >/dev/null 2>/dev/null
    _assert_status 1 $status 'go_to_bookmark rejects extra arguments'

    go_to_bookmark --unknown >/dev/null 2>/dev/null
    _assert_status 1 $status 'go_to_bookmark rejects unknown options'

    delete_bookmark one two >/dev/null 2>/dev/null
    _assert_status 1 $status 'delete_bookmark rejects extra arguments'

    delete_bookmark --unknown >/dev/null 2>/dev/null
    _assert_status 1 $status 'delete_bookmark rejects unknown options'

    bookmark_exists one two >/dev/null 2>/dev/null
    _assert_status 1 $status 'bookmark_exists rejects extra arguments'

    bookmark_exists --unknown >/dev/null 2>/dev/null
    _assert_status 1 $status 'bookmark_exists rejects unknown options'

    rename_bookmark old --unknown >/dev/null 2>/dev/null
    _assert_status 1 $status 'rename_bookmark rejects unknown options'

    rename_bookmark bad-name new_name >/dev/null 2>/dev/null
    _assert_status 1 $status 'rename_bookmark validates old bookmark names'

    save_bookmark first second >/dev/null 2>/dev/null
    _assert_status 1 $status 'save_bookmark rejects extra positional arguments'

    save_bookmark --unknown >/dev/null 2>/dev/null
    _assert_status 1 $status 'save_bookmark rejects unknown options'

    list_bookmarks extra >/dev/null 2>/dev/null
    _assert_status 1 $status 'list_bookmarks rejects unexpected arguments'

    fishmarks_doctor --unknown >/dev/null 2>/dev/null
    _assert_status 1 $status 'fishmarks_doctor rejects unknown options'
end

function _test_help_output
    set -l commands \
        save_bookmark \
        rename_bookmark \
        bookmark_exists \
        go_to_bookmark \
        print_bookmark \
        delete_bookmark \
        list_bookmarks \
        fishmarks_doctor

    for command_name in $commands
        set -l help_output ($command_name --help)
        _assert_status 0 $status "$command_name --help succeeds"
        string match -q '*save_bookmark*' -- "$help_output"
        _assert_true $status "$command_name --help includes command list"
    end
end

function _test_shell_escaped_paths
    set -l special_path "$HOME/work/special \"q\" \$d\\b"
    _prepare_dir "$special_path"
    save_bookmark specialchars
    _assert_status 0 $status 'save_bookmark supports special shell characters'

    set -l location (print_bookmark specialchars)
    _assert_status 0 $status 'print_bookmark resolves special shell characters'
    _assert_eq "$special_path" "$location" 'special shell characters round-trip correctly'

    set -l stored_line
    while read -l line
        if string match -rq '^export DIR_specialchars=' -- "$line"
            set stored_line "$line"
            break
        end
    end <"$SDIRS"

    string match -q 'export DIR_specialchars="*"' -- "$stored_line"
    _assert_true $status 'bookmark line uses export DIR_<name>="..." format'

    string match -q '*\$HOME/work/special*' -- "$stored_line"
    _assert_true $status 'bookmark line preserves $HOME prefix'

    string match -q '*\\"q\\"*' -- "$stored_line"
    _assert_true $status 'bookmark line escapes double quotes'

    string match -q '*\\$d*' -- "$stored_line"
    _assert_true $status 'bookmark line escapes dollar signs'

    string match -q '*\\\\b*' -- "$stored_line"
    _assert_true $status 'bookmark line escapes backslashes'
end

function _test_rejects_newline_paths
    set -l unsupported_path "$HOME/work/bad\nname"
    _prepare_dir "$unsupported_path"
    save_bookmark newlinepath >/dev/null 2>/dev/null
    _assert_status 1 $status 'save_bookmark rejects directories containing newlines'

    print_bookmark newlinepath >/dev/null 2>/dev/null
    _assert_status 1 $status 'rejected newline path bookmark is not written'
end

function _test_version_command
    set -l version_output (fishmarks_version)
    _assert_status 0 $status 'fishmarks_version command succeeds'
    string match -rq '^[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9.-]+)?$' -- "$version_output"
    _assert_true $status 'fishmarks_version returns semver-like output'
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

function _test_fishmarks_doctor
    set -l original_sdirs "$SDIRS"

    set -gx SDIRS "$HOME/.sdirs_doctor_ok"
    command mkdir -p -- "$HOME/doctor/ok"
    printf '\n' >"$SDIRS"
    printf '# fishmarks comments are ignored\n' >>"$SDIRS"
    printf 'export DIR_ok="\\$HOME/doctor/ok"\n' >>"$SDIRS"
    fishmarks_doctor >/dev/null
    _assert_status 0 $status 'fishmarks_doctor succeeds for clean bookmark file'

    set -gx SDIRS "$HOME/.sdirs_doctor_bad"
    printf 'not a bookmark\n' >"$SDIRS"
    printf 'export DIR_dup="\\$HOME/doctor/missing"\n' >>"$SDIRS"
    printf 'export DIR_dup="\\$HOME/doctor/missing-two"\n' >>"$SDIRS"
    fishmarks_doctor >/dev/null 2>/dev/null
    _assert_status 1 $status 'fishmarks_doctor reports malformed, duplicate, or missing directories'

    set -gx SDIRS "$original_sdirs"
end

_test_save_and_print
_test_default_name_generation
_test_save_requires_force_to_overwrite
_test_go_to_and_delete
_test_rename_bookmark
_test_bookmark_exists
_test_legacy_file_compatibility
_test_invalid_name_rejected
_test_list_names_only
_test_argument_validation
_test_shell_escaped_paths
_test_rejects_newline_paths
_test_version_command
_test_conf_aliases
_test_fishmarks_doctor
_test_help_output

if test $failures -gt 0
    printf '\n%d of %d assertions failed\n' "$failures" "$assertions"
    exit 1
end

set_color green
printf 'All %d assertions passed\n' "$assertions"
set_color normal
