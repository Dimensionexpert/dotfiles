# Dotfiles
Personal configuration files for my system.

Reseaon why I am making this :

- Rebuild my envoirment fast.
- track changes over time.

I made this lower the friction in my workflow not to optimize anything.

## Philosophy

The philosophy behind making this is to keep things simple. Make things more accessible without stripping the core. Reducing the reduandant typing of commands.

## Structure 

```text
dotfiles/
├── README.md
├── install.sh
├── .gitignore
├── alacritty/
│   ├── alacritty.toml
│   └── themes/
│       └── dank.toml
├── fish/
│   ├── config.fish
│   ├── conf.d/
│   │   ├── aliases.fish
│   │   ├── env.fish
│   │   └── paths.fish
│   ├── functions/
│   │   ├── ga.fish
│   │   ├── gc.fish
│   │   ├── gp.fish
│   │   ├── gacp.fish
│   │   ├── gui.fish
│   │   ├── cv.fish
│   │   ├── fish_prompt.fish
│   │   └── fish_right_prompt.fish
│   └── variables.fish
├── nvim/
│   └── init.lua
├── fuzzel/
│   └── fuzzel.ini
├── kitty/
│   └── kitty.conf
├── niri/
│   ├── config.kdl
│   └── config.original.kdl
```
Everything is managed using GNU stow.


## Fish Functions

Quick commands I use to daily to speed up my workflow.


### `ga` - Git Add Made Simple

**What it does:**  
Stages files for commit. If you don't specify any files, it stages everything. If you pass file names, it only stages those (and warns you if any don't exist).

**Usage:**  
```fish
ga                    # stages all changes
ga file1.txt file2.js # stages specific files
```

**Example:**  
```fish
# Stage everything
ga

# Stage specific files
ga README.md src/main.py

# It'll warn you if a file doesn't exist
ga nonexistent.txt
# Output: ga: warning — 'nonexistent.txt' not found
```


