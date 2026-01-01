function gacp
    if not git rev-parse --verify HEAD >/dev/null 2>&1
        echo "No commits yet. Create an initial commit before pushing."
        return 1
    end
    
    if test (count $argv) -ge 1
        # If message provided as argument
        ga; and gc $argv; and gp
    else
        # If no argument, gc will prompt for message
        ga; and gc; and gp
    end
end