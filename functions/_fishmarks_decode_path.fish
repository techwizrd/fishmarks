function _fishmarks_decode_path --argument-names raw_value
    set -l value "$raw_value"
    set -l quote_match (string match -r '^"(.*)"$' -- "$value")
    if test (count $quote_match) -gt 1
        set value "$quote_match[2]"
    else
        set quote_match (string match -r "^'(.*)'\$" -- "$value")
        if test (count $quote_match) -gt 1
            set value "$quote_match[2]"
        end
    end

    set value (string replace -a -- '\$HOME' "$HOME" "$value")
    set value (string replace -r -- '^\$HOME' "$HOME" "$value")
    set value (string replace -a -- '\`' '`' "$value")
    set value (string replace -a -- '\$' '$' "$value")
    set value (string replace -a -- '\"' '"' "$value")
    string replace -a -- "\\\\" "\\" "$value"
end
