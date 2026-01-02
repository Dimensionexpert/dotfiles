function gui

    # Git Update Index - manage skip-worktree files
    # Usage: gui -s <file>   (skip file)
    #        gui -ns <file>  (unskip file)
    #        gui -ls         (list skipped files)
    
    set flag $argv[1]
    set file $argv[2]
    
    # List skipped files
    if test "$flag" = "-ls"
        git ls-files -v | grep '^S'; or echo "Nothing is skipped yet."
        return
    end
    
    # Validate arguments
    if test -z "$flag" -o -z "$file"
        echo "usage: gui -s|-ns <file> OR gui -ls"
        return 1
    end
    
    # Does file exist on disk?
    if not test -e "$file"
        echo "error: file does not exist"
        return 1
    end
    
    # Is it tracked?
    if not git ls-files --error-unmatch "$file" >/dev/null 2>&1
        echo "error: file is not tracked by git"
        return 1
    end
    
    # Is it already skipped?
    set skipped (git ls-files -v -- "$file" | grep -q '^S'; and echo yes; or echo no)
    
    switch $flag
        case -s
            if test "$skipped" = yes
                echo "⚠️  already skipped: $file"
            else
                git update-index --skip-worktree "$file"
                echo "✅ skipped: $file"
            end
        case -ns
            if test "$skipped" = no
                echo "⚠️  not currently skipped: $file"
            else
                git update-index --no-skip-worktree "$file"
                echo "✅ unskipped: $file"
            end
        case '*'
            echo "usage: gui -s|-ns <file> OR gui -ls"
            return 1
    end
end