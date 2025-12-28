function nv
    if test (count $argv) -eq 0
        nvim        
        return
    end

    if test (count $argv) -lt 2
        echo "Usage: nv <base dir> <file path>"  
        return 1
    end

    set base ~/.config/$argv[1]
    set path (string join "/" $argv[2..-1])

    nvim $base/$path

end

