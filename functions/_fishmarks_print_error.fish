function _fishmarks_print_error --argument-names message
    set_color red >&2
    printf 'ERROR: %s\n' "$message" >&2
    set_color normal >&2
end
