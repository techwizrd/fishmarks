function _fishmarks_write_entries
    _fishmarks_ensure_sdirs

    set -l tmp_file (command mktemp)
    for entry in $argv
        set -l parts (string split -m 1 '=' -- "$entry")
        set -l encoded_path (_fishmarks_encode_path "$parts[2]")
        printf 'export DIR_%s="%s"\n' "$parts[1]" "$encoded_path"
    end >"$tmp_file"

    command mv -- "$tmp_file" "$SDIRS"
end
