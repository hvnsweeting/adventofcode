# Rust 2021

## Lessons
### Tooling setup
- Using rustup, not distro packages - which missing many things, like `rustup` command.
- Setup `rust-analyzer` via rustup for auto-complete, doc, etc...
- For vim with `vim-plug`: add `Plug 'Valloric/YouCompleteMe'`, use `:PlugInstall` then manually run
  `~/.vim/plugged/YouCompleteMe $ ./install.py --rust-completer`

### Language
- To do map/filter/enumerate... need to convert to type "Iterator" via `.iter()`
- To have a Vector, need `.collect<Vec<type>>`
- `.fold` takes arguments in `|acc, x|` not `x acc` like Elixir
