function go_to_bookmark --description "Go to (cd) to the directory associated with a bookmark"
    if test (count $argv) -lt 1
        _fishmarks_print_error "bookmark name required"
        return 1
    end

    set -l bookmark_name "$argv[1]"

    if _check_help "$bookmark_name"
        return 0
    end

    if test (count $argv) -ne 1
        _fishmarks_print_error "exactly one bookmark name is required"
        return 1
    end

    if string match -q -- '--*' "$bookmark_name"
        _fishmarks_print_error "unknown option '$bookmark_name'"
        return 1
    end

    set -l target (_fishmarks_find_path "$bookmark_name")
    if test -z "$target"
        _fishmarks_print_error "'$bookmark_name' bookmark does not exist"
        return 1
    end

    if test -d "$target"
        cd -- "$target"
        return 0
    end

    _fishmarks_print_error "'$target' does not exist"
    return 1
end
