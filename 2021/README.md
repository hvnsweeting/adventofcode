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
- D2. `.fold` takes arguments in `|acc, x|` not `x acc` like Elixir
- D3. `u32` instead of `i32`, most of problem would return an unsigned interger.
  vec.len() returns `usize`, which can convert to `u32` easier with `as u32`.
- D3. `let arr = vec![0; length];` to create a vector of length with default values 0. Note the `;`, weird syntax when `;` also used for line ending..
- `iter().collect()` would return a `Vec<&type>`, uses `.clone()` to create `Vec<type>`
- D3. `dbg!(x)` for faster debug print than `println!("{:?}", x)`.
- D3. lambda using in map() often should use `|&x|` instead of `|x|`, because the `iter().map()` would return a slice of references, like `Vec<&i32>`, use `&x` is pattern matching, make `x` captures the `i32` part only for types implement Copy trait (not Vec).
