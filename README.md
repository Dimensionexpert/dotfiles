# Dotfiles
Personal configuration files for my system.

Reseaon why I am making this :

- Rebuild my envoirment fast.
- track changes over time.

I made this lower the friction in my workflow not to optimize anything.

## Philosophy

The philosophy behind making this is to keep things simple. Make things more accessible without stripping the core. Reducing the reduandant typing of commands.

## Installation

### Prerequisites

Make sure you have the following installed:

- [Fish Shell](https://fishshell.com/) - Your shell
- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink manager
- [Git](https://git-scm.com/) - Version control

### Setup

1. **Clone the repository**
   ```fish
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Use Stow to symlink configs**
   ```fish
   # Symlink all configs
   stow */
   
   # Or symlink specific configs
   stow fish
   stow nvim
   stow alacritty
   ```

3. **Reload your shell**
   ```fish
   exec fish
   ```

### Platform Notes

- **macOS & Linux**: Both use `~/.config/` for configurations, so the setup is identical.
- Stow will create symlinks from `~/dotfiles/<config>/` to `~/.config/<config>/`.

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
│   │   ├── grp.fish 
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


### `ga` - Git Add with Group Exclusion

**What it does:**  
Stages files for commit with three modes: stage specific files, stage everything, or stage everything except a predefined group of files. Groups are managed using the `grp` function.

**Usage:**  
```fish
ga <files...>      # stage specific files
ga -al             # stage all changes
ga -ex <group>     # stage all except files in the group
```

---

**Mode 1: Stage Specific Files**

Pass one or more filenames to stage them individually.
```fish
# Stage a single file
ga README.md
# → ga: staged 1 file(s)

# Stage multiple files
ga src/main.py tests/test.py config.json
# → ga: staged 3 file(s)

# Stage with wildcards (fish expands them)
ga *.md
# → ga: staged 5 file(s)
```

**Note:** Git will error if you try to stage non-existent files, so make sure your files exist.

---

**Mode 2: Stage All Changes**

Use `-al` flag to stage everything in your working directory.
```fish
ga -al
# → ga: staged all changes

# Equivalent to: git add .
```

---

**Mode 3: Stage All EXCEPT a Group**

Use `-ex <group>` to stage all changes except files listed in a specific group. This is perfect for keeping sensitive files, temporary work, or debugging code out of commits.
```fish
# First, create a group (see grp function)
grp -ad secrets .env api_keys.txt config.local

# Then exclude that group when staging
ga -ex secrets
# → ga: staged all files except group 'secrets'

# The function filters out the group files automatically
# Only files NOT in the secrets group get staged
```

**How it works under the hood:**
1. Gets list of all changed files (`git status --porcelain`)
2. Extracts just the filenames (`awk '{print $2}'`)
3. Filters out files listed in the group (`grep -v -F -f $grpfile`)
4. Stages the remaining files (`xargs git add`)

---

**Error Handling**

The function handles several edge cases:
```fish
# No arguments - shows usage
ga
# → usage:
#     ga <files...>           - stage specific files
#     ga -al                  - stage all changes
#     ga -ex <group>          - stage all except group

# Group doesn't exist
ga -ex nonexistent
# → ga: group 'nonexistent' does not exist

# Missing group name
ga -ex
# → ga: missing group name

# All files are in the excluded group (nothing to stage)
ga -ex temp
# → ga: all files are excluded or no changes to stage

# Unknown flag
ga -xyz
# → ga: unknown flag '-xyz'
# → fuck i am out :|. Hand Your system to trusted adult and get your head checked RETARD!
```

---

**Real-World Workflow Example**
```fish
# Setup: Create groups for different file types
grp -ad secrets .env *.key config.local
grp -ad temp *.log debug.txt scratch.py

# Scenario 1: Working on features, exclude secrets
ga -ex secrets
gc "add new features"

# Scenario 2: Stage everything for a release
ga -al
gc "v1.0.0 release"

# Scenario 3: Stage specific file that's in a group
# (groups only affect -ex mode, not direct file staging)
ga .env
gc "update env template"

# Scenario 4: Quick commit without temp files
gacp -ex temp "fixed bug in auth"
```

---

**Tips**

- Groups are stored in `~/.groups/` as plain text files (one filename per line)
- You can have multiple groups and switch between them
- Use `grp -ls` to see all your groups at any time
- Files can be in multiple groups simultaneously
- The `-ex` flag processes ALL changed files, not just tracked ones
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

### `gacp` - The Full Workflow with Group Support

**What it does:**  
Runs the complete git workflow in one command: add, commit, and push. Supports all `ga` features including group exclusion. Chains the three operations together, stopping if any step fails.

**Usage:**  
```fish
gacp                              # stage all, prompt for message, push
gacp <ga-args> [commit message]   # stage with options, commit, push
```

---

**Workflow Modes**

**Mode 1: Stage All + Prompt**

No arguments stages everything and prompts you for a commit message.
```fish
gacp
# → ga: staged all changes
# → Commit message: [you type here]
# → [pushes to remote]
```

---

**Mode 2: Stage All with Message**

Pass `-al` with a commit message.
```fish
gacp -al updated documentation
# → ga: staged all changes
# → [main abc1234] updated documentation
# → [pushes to remote]
```

---

**Mode 3: Exclude Group**

Use `-ex <group>` to exclude files, then provide commit message.
```fish
gacp -ex secrets initial commit without secrets
# → ga: staged all files except group 'secrets'
# → [main def5678] initial commit without secrets
# → [pushes to remote]
```

---

**Mode 4: Stage Specific Files**

Pass filenames directly, followed by commit message.
```fish
gacp README.md updated readme
# → ga: staged 1 file(s)
# → [main ghi9012] updated readme
# → [pushes to remote]

# Without message - prompts you
gacp config.json
# → ga: staged 1 file(s)
# → Commit message: [you type here]
# → [pushes to remote]
```

---

**Error Handling**
```fish
# Brand new repo with no commits
gacp -al initial commit
# → No commits yet. Create an initial commit before pushing.

# If staging fails, commit and push won't run
gacp -ex nonexistent some message
# → ga: group 'nonexistent' does not exist
# [stops here, doesn't commit or push]

# If commit fails, push won't run
# (e.g., empty commit with no changes)
```

---

**How it works:**

Uses Fish's `and` operator to chain commands:
```fish
ga <args>; and gc <message>; and gp
```

If any step fails (returns non-zero exit code), the chain stops. This prevents pushing uncommitted changes or committing unstaged files.

---

**Real-World Examples**
```fish
# Quick fix and push
gacp -al hotfix: patch security issue

# Feature work without debug files
gacp -ex temp add user authentication

# Update single file
gacp index.html fixed typo in homepage

# Daily workflow - stage all, write detailed message
gacp
# → Commit message: refactor: split auth module into services
```

---

**Tips**

- The function checks if you have any commits before attempting to push
- All `ga` flags work: `-al`, `-ex <group>`, or direct file paths
- Commit messages can be multiple words (no quotes needed)
- If any step fails, the whole operation stops safely
- Use `gacp` without args when you want to review your commit message carefully

### `grp` - File Group Management

**What it does:**  
Creates and manages groups of files stored in `~/.groups/`. Each group is a plain text file containing one filename per line. Used with `ga -ex` to exclude files from staging.

**Usage:**  
```fish
grp -ad <group> <files...>  # add files to a group
grp -rm <group> <files...>  # remove files from a group
grp -ls                     # list all groups and their contents
```

---

**Creating and Adding to Groups**

Use `-ad` to add files to a group. If the group doesn't exist, it's created automatically.
```fish
# Create a new group with files
grp -ad secrets .env api_keys.txt config.local
# → 3 added to group 'secrets'

# Add more files to existing group
grp -ad secrets database.yml
# → 1 added to group 'secrets'

# Create group with wildcards (fish expands them)
grp -ad temp *.log *.tmp
# → 5 added to group 'temp'

# Error: no files provided
grp -ad mygroup
# → no files to add
```

**Note:** Files are appended to the group, so adding the same file twice will create duplicates (harmless but redundant).

---

**Removing Files from Groups**

Use `-rm` to remove specific files from a group.
```fish
# Remove single file
grp -rm secrets config.local
# → 1 removed from group 'secrets'

# Remove multiple files
grp -rm temp debug.log error.log
# → 2 removed from group 'temp'

# Error: group doesn't exist
grp -rm nonexistent file.txt
# → group 'nonexistent' does not exist
```

**How it works:** Uses `grep -v -F` to filter out the specified files, then overwrites the group file with the filtered result.

---

**Listing Groups**

Use `-ls` to see all groups and their contents in a tree view.
```fish
grp -ls
# → .groups
#   ├── secrets
#   └── temp
#   1 directory, 2 files
```

The listing shows the directory structure of `~/.groups/` with all group files. To see what's inside a specific group:
```fish
cat ~/.groups/secrets
# → .env
#   api_keys.txt
#   config.local
```

---

**Real-World Workflow**
```fish
# Setup: Create groups for different purposes
grp -ad secrets .env *.key passwords.txt
grp -ad temp *.log scratch.* debug_*
grp -ad wip experimental.py draft.md notes.txt

# Check what groups you have
grp -ls
# → .groups
#   ├── secrets
#   ├── temp
#   └── wip

# Use groups with ga to exclude files
ga -ex secrets      # stage everything except secrets
ga -ex temp         # stage everything except temp files

# Update groups as needed
grp -ad wip feature_draft.py
grp -rm temp old.log

# Clean up - remove entire groups
rm ~/.groups/wip
```

---

**Group File Format**

Groups are stored as plain text files in `~/.groups/`:
```text
~/.groups/
├── secrets
├── temp
└── wip
```

Each group file contains one filename per line:
```text
# Contents of ~/.groups/secrets
.env
api_keys.txt
config.local
database.yml
```

You can manually edit these files if needed:
```fish
nano ~/.groups/secrets
# or
code ~/.groups/secrets
```

---

**Tips**

- Groups persist across sessions (stored in `~/.groups/`)
- Files can exist in multiple groups simultaneously
- Group names can be anything (no `.groups` extension needed)
- The function creates `~/.groups/` automatically if it doesn't exist
- Use descriptive group names: `secrets`, `temp`, `wip`, `build-artifacts`, etc.
- Removing a file from a group doesn't delete the actual file, just removes it from the group list

---

**Common Use Cases**
```fish
# Sensitive configuration
grp -ad secrets .env *.key config.local credentials.json

# Build artifacts and temp files
grp -ad build dist/ *.pyc __pycache__/ .cache/

# Work in progress
grp -ad wip draft_* experimental_* TODO.md

# Large binary files
grp -ad binaries *.mp4 *.zip *.tar.gz

# Platform-specific files
grp -ad windows *.exe *.dll
grp -ad macos .DS_Store *.app
```
### `gui` - Git Update Index Helper

**What it does:**  
Manages skip-worktree files. Useful when you want to keep a tracked file but ignore local changes (like config files with personal settings).

**Usage:**  
```fish
gui -s  <file>  # skip a file (ignore local changes)
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

## TODO

Features and improvements I want to add:

### Functions to Enhance

- [ ] **`cv` - Make it more flexible**
  - Add flags to choose editor: `-c` for code, `-n` for nvim.
  - Add flag to set parent directory (not just `~/.config`).
  - Make it work with any editor, not just VS Code.

- [✅] **`gp` - Add group push**
  - Implement group function to push to multiple remotes at once.

### New Functions to Add

- [ ] TBD as workflow needs evolve.
- [ ] Work on Adits suggestions.a