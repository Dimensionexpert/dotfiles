function wb
    if pgrep waybar > /dev/null 2>&1
        pkill waybar
    end
    waybar & disown
end