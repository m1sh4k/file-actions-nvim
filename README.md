## Description

This is a script written in pure lua which is made to create neovim commands (for easier keybindings setup) depending on opened filetype.

## Installation

### Lazy.nvim installation
```lua
{'m1sh4k/file-actions-nvim', config=true},
```

## Commands

+ `:FileActionsExecuteCode` — run code if build succed, else show build errors.
+ `:FileActionsExamineCode`
    - for `python` ruff check.
    - for `c` build code, run with valgrind if build succed, else show build errors.
+ `:FileActionsMakeRun` — run `make run` command in opened file directory.
+ `:FileActionsMakeRunValgrind` — run `make run_valgrind` command in opened file directory.
