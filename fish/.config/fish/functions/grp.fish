function grp
    set GROUP_DIR ~/.groups
    mkdir -p $GROUP_DIR

    set flag $argv[1]
    set grpname $argv[2]
    set files $argv[3..-1]

    # Skip validation if flag is -ls
    if test "$flag" != "-ls"; and test -z "$grpname"
        echo "usage:"
        echo "  grp -ad <group> <files...>"
        echo "  grp -rm <group> <files...>"
        echo "  grp -ls"
        return 1
    end

    set grpfile $GROUP_DIR/$grpname

    switch $flag
        case -ad
            if test (count $files) -eq 0
                echo "no files to add"
                return 1
            end

            printf "%s\n" $files >> $grpfile
            echo (count $files)" added to group '$grpname'"

        case -rm
            if not test -f $grpfile
                echo "group '$grpname' does not exist"
                return 1
            end

            grep -v -F $files $grpfile > /tmp/grp.tmp
            mv /tmp/grp.tmp $grpfile
            echo (count $files)" removed from group '$grpname'"

        case -ls
            tree -a $GROUP_DIR | sed '1s|.*|.groups|'
            
        case '*'
            echo "unknown flag '$flag'"
            return 1
    end
end
