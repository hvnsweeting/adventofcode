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
- D4. Use `.cloned()` instead of `.map(|&x| x)`, equivalent code.
- D4. most of functions do not want to own its arguments, thus declare to use a reference, e.g `fn foo(v &Vec<u32>)` and when call function, pass the reference, `foo(&v)`. NOTICE the & before the type when declare, but & before the var when call.
- D4. use `.clone()` to workaround with owner-borrow, when need `Vec<i32>` but got `Vec<&i32>`, but learn owner-borrow after the rush hour.
- D4. A solution for error `.collect();  value of type HashSet<u32> cannot be built from std::iter::Iterator<Item=&u32>` is put `.map(|&i| i)` before collect.
- D4. passing references are better than using `.clone()` if possible.
- D4. `.replace()` creates a String, `split()` borrows it, after line 9, the String is dropped because no variable holds it till out of scope, thus errored. The fix is to assign `s.replace()` to a var to hold it longer.
  ```rust
    error[E0716]: temporary value dropped while borrowed
    --> src/lib.rs:9:13
     |
  9  |     let v = s.replace("\n", " ").split(" ");
     |             ^^^^^^^^^^^^^^^^^^^^           - temporary value is freed at the end of this statement
     |             |
     |             creates a temporary which is freed while still in use
  10 |     dbg!(v);
     |          - borrow later used here
     |
     = note: consider using a `let` binding to create a longer lived value
  ```
- D4. `let set: HashSet<u32> = HashSet::<u32>::new()`, notice the turbofish ::<> when call, but type declaration on left hand side does not have.
- D5. Range does not have 10..1, has only 1..10. Use 1..=10 if need inclusive. Can use `(1..10).rev()`
  to get 10,9,8 ...
- D5. To add elements to HashSet, write a for loop then `set.add(i)`.
- D5. When error hard to read (in Vim), run the code, the console message often more
  details, easy to understand, including fixes.
- D5. HashMap may more "generic" than HashSet solution. For instance, to find intersection of
  multiple lines, HashSet works. But if question ask find point that 3 lines intersect,
  only HashMap can answer. So HashMap is better in this case.
- D6. `u32` was not enough for day 6 result part 2. Let's default to `u64`.
- D6. if keys are static numbers, vector can be used instead of map.
- D6. it's [not simple to iterate & modify value of a `HashMap`](https://stackoverflow.com/questions/45724517/how-to-iterate-through-a-hashmap-print-the-key-value-and-remove-the-value-in-ru) but easier to iterate numeric index of vector.
- D6. it's not simple to iterate & modify a vec. Use `index in 0..vec.len()` instead.
- D6. put `()` around range `1..=10` works but `1..=10.map()` does not.
- D6. if there is a "simutation" problem, avoid simulate it and use other way
  to calculate the result. Simulation not scale in part2.
- D7. `u64` makes it hard to calculate abs (because there is no negative number), use `i64` as default.
- D7. `min` and `max` need `.unwrap().cloned()`, because `min` of empty iterator returns `None`.
- D7. `let &min` to auto deference, avoid to write `.cloned()`.
- D8. A built-in method can accept `x` or `&x`, it's up to it to own or borrow, and most want borrow only, thus use `&x`.
  `vec![1,2,3].contains(&2);`

