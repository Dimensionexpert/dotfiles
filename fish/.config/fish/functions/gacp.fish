function gacp
    if not git rev-parse --verify HEAD >/dev/null 2>&1
        echo "No commits yet. Create an initial commit before pushing."
        return 1
    end
    
    ga; and gc; and gp
end