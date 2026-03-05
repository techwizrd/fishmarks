function _fishmarks_encode_path --argument-names path_value
    set -l escaped_home (string escape --style=regex -- "$HOME")
    set -l value (string replace -r -- "^$escaped_home" '__FISHMARKS_HOME_PREFIX__' "$path_value")
    set value (string replace -a -- '\\' '\\\\' "$value")
    set value (string replace -a -- '"' '\\"' "$value")
    set value (string replace -a -- '$' '\\$' "$value")
    set value (string replace -a -- '`' '\\`' "$value")
    string replace -a -- __FISHMARKS_HOME_PREFIX__ '\$HOME' "$value"
end
