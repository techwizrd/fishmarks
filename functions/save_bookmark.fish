function save_bookmark --description "Save the current directory as a bookmark"
    set -l bn "$argv[1]"
    if test (count $argv) -lt 1
        set bn (string replace -ra -- '[^A-Za-z0-9]' '_' (path basename -- "$PWD"))
    end

    if not _fishmarks_valid_name "$bn"
        _fishmarks_print_error 'Bookmark names may only contain alphanumeric characters and underscores.'
        return 1
    end

    if not _fishmarks_path_supported "$PWD"
        _fishmarks_print_error 'Current directory path contains unsupported newline or carriage-return characters.'
        return 1
    end

    set -l updated_entries
    for entry in (_fishmarks_entries)
        set -l parts (string split -m 1 '=' -- "$entry")
        if test "$parts[1]" = "$bn"
            continue
        end
        set -a updated_entries "$entry"
    end

    set -a updated_entries "$bn=$PWD"
    _fishmarks_write_entries $updated_entries
    return 0
end
