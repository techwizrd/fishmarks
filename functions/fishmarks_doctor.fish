function fishmarks_doctor --description "Check fishmarks data file for common issues"
    if _check_help "$argv[1]"
        return 0
    end

    set -l fix 0
    set -l assume_yes 0
    for arg in $argv
        switch "$arg"
            case --fix
                set fix 1
            case --yes
                set assume_yes 1
            case '*'
                _fishmarks_print_error "unknown option '$arg'"
                return 1
        end
    end

    if test $assume_yes -eq 1; and test $fix -ne 1
        _fishmarks_print_error '--yes requires --fix'
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
    set -l retained_lines

    while read -l line
        if test -z "$line"
            set -a retained_lines "$line"
            continue
        end

        if string match -q -- '#*' "$line"
            set -a retained_lines "$line"
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
            continue
        end

        set -a names_seen "$bookmark_name"
        set -a retained_lines "$line"

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

    set -l total_issues (math $malformed_count + $duplicate_count + $missing_directory_count + $invalid_path_count)
    set -l remaining_issues $total_issues
    set -l safe_fix_count (math $malformed_count + $duplicate_count)

    if test $fix -eq 1
        if test $safe_fix_count -eq 0
            printf 'fishmarks doctor: no safe fixes available (%s)\n' "$SDIRS"
            printf 'fishmarks doctor: %d issue(s) found (%s)\n' $total_issues "$SDIRS"
            return 1
        end

        if test $assume_yes -ne 1
            while true
                printf 'Apply safe fixes to %s? [y/N] ' "$SDIRS"
                read -l confirmation

                switch (string lower -- "$confirmation")
                    case y yes
                        break
                    case '' n no
                        printf 'fishmarks doctor: fix cancelled (%s)\n' "$SDIRS"
                        printf 'fishmarks doctor: %d issue(s) found (%s)\n' $total_issues "$SDIRS"
                        return 1
                end
            end
        end

        set -l tmp_file (command mktemp)
        for retained_line in $retained_lines
            printf '%s\n' "$retained_line"
        end >"$tmp_file"
        command mv -- "$tmp_file" "$SDIRS"

        set -l removed_label entries
        if test $safe_fix_count -eq 1
            set removed_label entry
        end
        printf 'fishmarks doctor: removed %d malformed or duplicate %s (%s)\n' $safe_fix_count "$removed_label" "$SDIRS"

        set remaining_issues (math $missing_directory_count + $invalid_path_count)
        if test $remaining_issues -eq 0
            printf 'fishmarks doctor: OK (%s)\n' "$SDIRS"
            return 0
        end
    end

    printf 'fishmarks doctor: %d issue(s) found (%s)\n' $remaining_issues "$SDIRS"
    return 1
end
