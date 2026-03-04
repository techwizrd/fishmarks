function _fishmarks_encode_path --argument-names path_value
    set -l escaped_home (string escape --style=regex -- "$HOME")
    string replace -r -- "^$escaped_home" '\$HOME' "$path_value"
end
