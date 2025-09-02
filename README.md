## Description

This is a script written in pure lua which is made to create neovim commands (for easier keybindings setup) depending on opened filetype.

### e.g. command: :FileActionsExecuteCode
This is the only command that will appear after installation. If you will open python file (\*.py) it will run your python script with `python3 <file>`. If you will open C++ file (\*.cpp, \*.cxx) it will compile and run the progamm if there were no errors during compilation. Same for C.

## Installation

### Lazy.nvim installation
```lua
{'m1sh4k/file-actions-nvim', config=true},
```
