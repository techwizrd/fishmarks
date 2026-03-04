function _valid_bookmark
    if test (count $argv) -lt 1
        return 1
    end

    _fishmarks_find_path "$argv[1]" >/dev/null
end
