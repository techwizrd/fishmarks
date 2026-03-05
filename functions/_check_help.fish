function _check_help
    if test (count $argv) -lt 1
        return 1
    end

    if contains -- "$argv[1]" -h -help --help
        echo ''
        echo 's <bookmark_name> - Saves the current directory as "bookmark_name"'
        echo 'g <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"'
        echo 'p <bookmark_name> - Prints the directory associated with "bookmark_name"'
        echo 'd <bookmark_name> - Deletes the bookmark'
        echo 'l - Lists all available bookmarks'
        echo ''
        return 0
    end
    return 1
end
