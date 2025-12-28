function ga
    if test (count $argv) -eq 0
        echo "ga: staging all changes"
        git add .
        return
    end

    set valid_files

    for file in $argv
        if test -e "$file"
            set valid_files $valid_files $file
        else
            echo "ga: warning — '$file' not found"
        end
    end

    if test (count $valid_files) -gt 0
        git add $valid_files
    else
        echo "ga: nothing to add"
    end
end
