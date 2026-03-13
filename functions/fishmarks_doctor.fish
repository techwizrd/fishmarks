function fishmarks_doctor --description "Check fishmarks data file for common issues"
    if _check_help "$argv[1]"
        return 0
    end

    if test (count $argv) -gt 0
        _fishmarks_print_error "unknown option '$argv[1]'"
        return 1
    end

    _fishmarks_ensure_sdirs

    if not test -r "$SDIRS"
        _fishmarks_print_error "cannot read '$SDIRS'"
        return 1
    end

    if not test -w "$SDIRS"
        _fishmarks_print_error "cannot write '$SDIRS'"
        return 1
    end

    set -l malformed_count 0
    set -l duplicate_count 0
    set -l missing_directory_count 0
    set -l invalid_path_count 0
    set -l names_seen

    while read -l line
        if test -z "$line"
            continue
        end

        if string match -q -- '#*' "$line"
            continue
        end

        set -l entry (string match -r '^export[[:space:]]+DIR_([^=]+)=(.+)$' -- "$line")
        if test (count $entry) -lt 3
            set malformed_count (math $malformed_count + 1)
            printf 'Malformed line: %s\n' "$line"
            continue
        end

        set -l bookmark_name "$entry[2]"
        set -l raw_path "$entry[3]"

        if not _fishmarks_valid_name "$bookmark_name"
            set malformed_count (math $malformed_count + 1)
            printf 'Invalid bookmark name: %s\n' "$bookmark_name"
            continue
        end

        if contains -- "$bookmark_name" $names_seen
            set duplicate_count (math $duplicate_count + 1)
            printf 'Duplicate bookmark name: %s\n' "$bookmark_name"
        else
            set -a names_seen "$bookmark_name"
        end

        set -l decoded_path (_fishmarks_decode_path "$raw_path")
        if not _fishmarks_path_supported "$decoded_path"
            set invalid_path_count (math $invalid_path_count + 1)
            printf 'Unsupported path characters in bookmark: %s\n' "$bookmark_name"
            continue
        end

        if not test -d "$decoded_path"
            set missing_directory_count (math $missing_directory_count + 1)
            printf 'Missing directory for bookmark %s: %s\n' "$bookmark_name" "$decoded_path"
        end
    end <"$SDIRS"

    if test $malformed_count -eq 0; and test $duplicate_count -eq 0; and test $missing_directory_count -eq 0; and test $invalid_path_count -eq 0
        printf 'fishmarks doctor: OK (%s)\n' "$SDIRS"
        return 0
    end

    printf 'fishmarks doctor: %d issue(s) found (%s)\n' (math $malformed_count + $duplicate_count + $missing_directory_count + $invalid_path_count) "$SDIRS"
    return 1
end
