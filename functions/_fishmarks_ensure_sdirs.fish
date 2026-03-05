function _fishmarks_ensure_sdirs
    if not set -q SDIRS
        set -gx SDIRS "$HOME/.sdirs"
    end

    command mkdir -p -- (path dirname -- "$SDIRS")
    if not test -e "$SDIRS"
        command touch -- "$SDIRS"
    end
end
