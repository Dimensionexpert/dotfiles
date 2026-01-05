function gacp
    if not git rev-parse --verify HEAD >/dev/null 2>&1
        echo "No commits yet. Create an initial commit before pushing."
        return 1
    end
    
    if test (count $argv) -ge 1
        set flag $argv[1]
        
        # Check if it's a ga flag
        if string match -q -- "-*" $flag
            # It's a flag like -al or -ex
            if test "$flag" = "-ex"
                # Need group name
                ga $flag $argv[2]; and gc $argv[3..-1]; and gp
            else
                # Just -al
                ga $flag; and gc $argv[2..-1]; and gp
            end
        else
            # It's files
            ga $argv[1]; and gc $argv[2..-1]; and gp
        end
    else
        # No args - stage all and prompt for commit
        ga -al; and gc; and gp
    end
end
# W function I am proud of this function. 