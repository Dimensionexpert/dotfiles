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


### `ga` - Git Add 

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
### `gc` - Quick Commits

**What it does:**  
Commits your staged changes with a message. Pass the message as arguments, or it'll prompt you for one.

**Usage:**  
```fish
gc your commit message here   # commit with inline message
gc                            # prompts you for a message
```

**Example:**  
```fish
# Write message directly
gc fixed the bug in login form

# Or get prompted
gc
# → Commit message: [you type here]
```

### `gp` - Smart Push

**What it does:**  
Pushes your commits to remote. If upstream isn't set, it asks if you want to set it up (with sensible defaults).

**Usage:**  
```fish
gp  # push to remote
```

**Example:**  
```fish
# If upstream is already set, just pushes
gp

# If not set, it prompts you
gp
# → Set upstream? [y/N]: y
# → Remote (default: origin): [press enter for origin]
# → Branch: [press enter to use current branch]

# Or skip setting upstream
gp
# → Set upstream? [y/N]: n
# → Pushing without setting upstream
```

### `gacp` - The Full Workflow

**What it does:**  
Runs the complete git workflow in one command: add, commit, and push. Takes a commit message as arguments or prompts you for one.

**Usage:**  
```fish
gacp your commit message  # stages, commits, and pushes
gacp                      # same but prompts for message
```

**Example:**  
```fish
# All in one go
gacp updated documentation

# Or get prompted for the message
gacp
# → Commit message: [you type here]
# → [stages, commits, then pushes]

# Won't work on a brand new repo with no commits
gacp
# → No commits yet. Create an initial commit before pushing.
```

### `gui` - Git Update Index Helper

**What it does:**  
Manages skip-worktree files. Useful when you want to keep a tracked file but ignore local changes (like config files with personal settings).

**Usage:**  
```fish
gui -s <file>   # skip a file (ignore local changes)
gui -ns <file>  # unskip a file (track changes again)
gui -ls         # list all skipped files
```

**Example:**  
```fish
# Skip a config file you've customized locally
gui -s config.json
# → ✅ skipped: config.json

# See what's currently skipped
gui -ls
# → S config.json

# Start tracking it again
gui -ns config.json
# → ✅ unskipped: config.json

# It'll warn you if something's off
gui -s notreal.txt
# → error: file does not exist
```

**Why use this?**  
Better than `.gitignore` for files that need to be in the repo but you want to modify locally without committing those changes.

### `cv` - Config VS Code Shortcut

**What it does:**  
Opens VS Code, with shortcuts for config files. No arguments opens VS Code normally. One argument opens that path. Two or more treats the first as a config folder and joins the rest as a path inside it.

**Usage:**  
```fish
cv                    # opens VS Code
cv ~/projects/myapp   # opens that folder
cv nvim init.lua      # opens ~/.config/nvim/init.lua
cv fish functions/    # opens ~/.config/fish/functions/
```

**Example:**  
```fish
# Just launch VS Code
cv

# Open a project
cv ~/dev/my-website

# Quick access to config files
cv alacritty alacritty.toml
# Opens: ~/.config/alacritty/alacritty.toml

cv fish conf.d/aliases.fish
# Opens: ~/.config/fish/conf.d/aliases.fish
```


