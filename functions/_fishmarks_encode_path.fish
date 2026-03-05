function _fishmarks_encode_path --argument-names path_value
    set -l escaped_home (string escape --style=regex -- "$HOME")
    set -l value "$path_value"
    set -l home_suffix

    if string match -rq -- "^$escaped_home" "$path_value"
        set home_suffix (string replace -r -- "^$escaped_home" '' "$path_value")
        set value "$home_suffix"
    end

    set value (string replace -a -- '\\' '\\\\' "$value")
    set value (string replace -a -- '"' '\\"' "$value")
    set value (string replace -a -- '$' '\\$' "$value")
    set value (string replace -a -- '`' '\\`' "$value")

    if set -q home_suffix
        printf '\$HOME%s\n' "$value"
    else
        printf '%s\n' "$value"
    end
end
