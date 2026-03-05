if set -q __fishmarks_conf_loaded
    return
end
set -g __fishmarks_conf_loaded 1

_fishmarks_ensure_sdirs

complete -e -c print_bookmark
complete -e -c delete_bookmark
complete -e -c go_to_bookmark

complete -c print_bookmark -a '(_fishmarks_complete)' -f
complete -c delete_bookmark -a '(_fishmarks_complete)' -f
complete -c go_to_bookmark -a '(_fishmarks_complete)' -f

if not set -q NO_FISHMARKS_COMPAT_ALIASES
    alias s save_bookmark
    alias g go_to_bookmark
    alias p print_bookmark
    alias d delete_bookmark
    alias l list_bookmarks

    complete -e -c p
    complete -e -c d
    complete -e -c g
    complete -c p -w print_bookmark
    complete -c d -w delete_bookmark
    complete -c g -w go_to_bookmark
end
