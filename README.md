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
├── alacritty/
│   ├── alacritty.toml
│   └── dank-theme.toml
├── fish/
│   ├── conf.d/
│   ├── config.fish
│   ├── fish_variables
│   └── functions/
│       └── fish_prompt.fish
├── fuzzel/
│   └── fuzzel.ini
├── kitty/
│   └── kitty.conf
├── niri/
│   ├── config.kdl
│   └── OriginalConfig.kdl
└── nvim/
    └── init.lua
```
Everything is managed using stow.



