function delete_bookmark --description "Delete a bookmark"
    if test (count $argv) -lt 1
        _fishmarks_print_error "bookmark name required"
        return 1
    end

    set -l removed 0
    set -l updated_entries
    for entry in (_fishmarks_entries)
        set -l parts (string split -m 1 '=' -- "$entry")
        if test "$parts[1]" = "$argv[1]"
            set removed 1
            continue
        end
        set -a updated_entries "$entry"
    end

    if test $removed -eq 0
        _fishmarks_print_error "bookmark '$argv[1]' does not exist"
        return 1
    end

    _fishmarks_write_entries $updated_entries
end
