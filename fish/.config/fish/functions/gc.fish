function gc
    if test (count $argv) -gt 0
        git commit -m "$argv"
    else 
        read -P " Commit message: " msg
        git commit -m "$msg"
    end
end
