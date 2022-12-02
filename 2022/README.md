# clj2022

A Clojure library designed to solve Advent of Code 2022.

## Setup
- install emacs & lein (clojure popular build tool): sudo apt install -y leiningen emacs
- lein new projectname; cd projectname; lein test # this will install clojure
### Config emacs
- To install package cider, type Alt-x then bottom left emacs shows "M-x", enter: package-refresh-contents
- Wait a bit, then type Alt-x enter: package-install , hit enter, then type cider 
- After installation done, Alt-x then type: cider-jack-in, emacs will open 2nd panel on the right and you have a Clojure REPL.

- Emacs terminology: M - meta - normally the Alt button, C - control - normally the Ctrl on keyboard.

## Lessons
### Emacs
- Use mouse choose on menubar > CIDER interaction / CIDER eval menus if not familiar with shortcut yet.
- Use C-c C-k (Ctrl c Ctrl k) to evaluated current file (emacs called buffer).
- Use M-x cider-format-buffer to format current file
- Run test: open the test file, eval by C-c C-k then run test under cursor: C-c C-t t
- Run all tests in file: C-c C-t n
- Put the function want to run to the latest line, result will be shown after evaluated, this is like click "Run" buttons on IDE.

### Clojure
- Anonymous function (lambda) cannot be nested.
- If processing a list, and each element is another list (so, nested list), write separated function to map: (map process_each list)
- Java function must be wrapped (map #(Integer/parse %) list)
- Order is not persistent as in Elixir, (map fun collections) but (clojure.string/split string #"regex"), thus it is hard to use thread macro (->> s f1 f2) to pass result as last argument. Thus have to use (as-> s x (f1 x) (f2 x)) to specify order of x. BUT [this](https://stackoverflow.com/questions/50275513/rules-of-thumb-for-function-arguments-ordering-in-clojure) explain why. Thus, if only first one split string take diff order, use it as first function in thread, the rest all follow the rule of processing sequences. (->> (string.split s #" ") (map f) (filter f))
- Map can be used as function to get value from key (mymap mykey)
- To unpack, use (let [[a b] '(1 2 3) (println a b)]), a = 1 and b = 2, note the [a b] must be [].