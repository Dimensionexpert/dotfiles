function gp
    # Check if upstream is already set
    git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1
    set has_upstream $status

    if test $has_upstream -eq 0
        # Upstream exists, just push
        git push
        return
    end

    # No upstream set
    read -P "Set upstream? [y/N]: " answer

    if contains "$answer"  y Y yes Yes YES 
        read -P "Remote (default: origin): " remote
        read -P "Branch: " branch

        if test -z "$remote"
            set remote origin
        end
        if test -z "$branch"
            set branch (git branch --show-current)
        end

        git push -u "$remote" "$branch"
  
    else
        echo "Pushing without setting upstream"
        git push
    end
end

