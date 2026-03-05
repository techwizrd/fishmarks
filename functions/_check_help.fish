function _check_help
    if test (count $argv) -lt 1
        return 1
    end

    if contains -- "$argv[1]" -h -help --help
        echo ''
        echo 'save_bookmark <bookmark_name> - Saves the current directory as "bookmark_name"'
        echo 'go_to_bookmark <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"'
        echo 'print_bookmark <bookmark_name> - Prints the directory associated with "bookmark_name"'
        echo 'delete_bookmark <bookmark_name> - Deletes the bookmark'
        echo 'list_bookmarks - Lists all available bookmarks'
        if not set -q NO_FISHMARKS_COMPAT_ALIASES
            echo ''
            echo 'Compatibility aliases: s g p d l'
        end
        echo ''
        return 0
    end
    return 1
end
