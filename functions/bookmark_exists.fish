function bookmark_exists --description "Check whether a bookmark exists"
    if test (count $argv) -lt 1
        _fishmarks_print_error "bookmark name required"
        return 1
    end

    if _check_help "$argv[1]"
        return 0
    end

    if test (count $argv) -ne 1
        _fishmarks_print_error "exactly one bookmark name is required"
        return 1
    end

    if string match -q -- '--*' "$argv[1]"
        _fishmarks_print_error "unknown option '$argv[1]'"
        return 1
    end

    _fishmarks_find_path "$argv[1]" >/dev/null
    return $status
end
