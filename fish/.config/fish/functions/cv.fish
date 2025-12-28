function cv
    if test (count $argv) -eq 0
        code 
        return
    end

    if test (count $argv) -lt 2
        echo "Usage: cv <base dir> <file path>"
        return 1
    end

    set base ~/.config/$argv[1]
    set path (string join "/" $argv[2..-1])

    code $base/$path

end 