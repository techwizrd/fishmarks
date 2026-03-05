function _fishmarks_valid_name --argument-names bookmark_name
    string match -rq '^[A-Za-z0-9_]+$' -- "$bookmark_name"
end
