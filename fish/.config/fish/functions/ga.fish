function ga
    set GROUP_DIR ~/.groups

    if test (count $argv) -eq 0
        echo "usage:"
        echo "  ga <files...>           - stage specific files"
        echo "  ga -al                  - stage all changes"
        echo "  ga -ex <group>          - stage all except group"
        return 1
    end

    # Check if first argument is a flag
    if string match -q -- "-*" $argv[1]
        set flag $argv[1]

        switch $flag
            case "-al"
                git add .
                echo "ga: staged all changes"
                return

            case "-ex"
                if test (count $argv) -lt 2
                    echo "ga: missing group name"
                    return 1
                end

                set grpname $argv[2]
                set grpfile $GROUP_DIR/$grpname

                if not test -f $grpfile
                    echo "ga: group '$grpname' does not exist"
                    return 1
                end

                git status --porcelain \
                | awk '{print $2}' \
                | grep -v -F -f $grpfile \
                | xargs git add

                if test $status -ne 0
                    echo "ga: all files are excluded or no changes to stage"
                    return 1
                end

                echo "ga: staged all files except group '$grpname'"
                return

            case '*'
                echo "ga: unknown flag '$flag'"
                echo "fuck, I am out :|. Hand Your system to trusted adult and get your head checked RETARD!"
                return 1
        end
    else
        # Not a flag, treat as files
        git add $argv
        echo "ga: staged" (count $argv) "file(s)"
    end
end