function cv
    if test (count $argv) -eq 0
        code
        return
    end

    if test (count $argv) -eq 1
        code $argv
        return
    end

    # 2 or more arguments
    set base ~/.config/$argv[1]
    set path (string join "/" $argv[2..-1])

    code $base/$path
end
