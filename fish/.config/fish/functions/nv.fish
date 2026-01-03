function nv
    if test (count $argv) -eq 0
        nvim
        return
    end

    if test (count $argv) -eq 1
        nvim $argv
        return
    end

    # 2 or more arguments
    set base ~/.config/$argv[1]
    set path (string join "/" $argv[2..-1])

    nvim $base/$path
end
