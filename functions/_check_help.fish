function _check_help
    if test (count $argv) -lt 1
        return 1
    end

    if contains -- "$argv[1]" -h -help --help
        echo ''
        echo 'save_bookmark [--force] [bookmark_name] - Saves the current directory as "bookmark_name"'
        echo 'rename_bookmark <old_name> <new_name> - Renames an existing bookmark'
        echo 'bookmark_exists <bookmark_name> - Returns success if bookmark exists'
        echo 'go_to_bookmark <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"'
        echo 'print_bookmark <bookmark_name> - Prints the directory associated with "bookmark_name"'
        echo 'delete_bookmark <bookmark_name> - Deletes the bookmark'
        echo 'list_bookmarks [--names-only] [--missing] - Lists available bookmarks'
        echo 'fishmarks_doctor [--fix] [--yes] - Checks bookmarks file for common issues'
        if not set -q NO_FISHMARKS_COMPAT_ALIASES
            echo ''
            echo 'Compatibility aliases: s g p d l'
        end
        echo ''
        return 0
    end
    return 1
end
