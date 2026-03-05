function _fishmarks_path_supported --argument-names path_value
    if string match -q "*\n*" -- "$path_value"
        return 1
    end

    if string match -q "*\r*" -- "$path_value"
        return 1
    end

    return 0
end
