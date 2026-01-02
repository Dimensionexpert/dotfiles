# Dotfiles
Personal configuration files for my system.

Reseaon why I am making this :

- Rebuild my envoirment fast.
- track changes.

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
Everything is managed using stow.



