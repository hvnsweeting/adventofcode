# clj2022

A Clojure library designed to solve Advent of Code 2022.

## Setup
- install emacs & lein (clojure popular build tool): sudo apt install -y leiningen emacs
- lein new projectname; cd projectname; lein test # this will install clojure
- Using other editors than Emacs is feasible Intellij, Vim, VScode <https://clojure.org/guides/editors>

## Doc
Quick docs

- https://clojure.org/guides/learn/
- https://learnxinyminutes.com/docs/clojure/
- https://clojure.org/api/cheatsheet

### Config emacs
- Emacs terminology: M: meta - normally the Alt button, C: control - normally the Ctrl on keyboard.
- To install package cider, type M-x then bottom left emacs shows "M-x", enter: `package-refresh-contents`
- Wait a bit, then type M-x enter: `package-install` , hit enter, then type `cider`
- type M-x enter: `package-install` , hit enter, then type `clojure-mode`
- After installation done, Alt-x then type: `cider-jack-in`, emacs will open 2nd panel on the right and you have a Clojure REPL. Ref: <https://www.braveclojure.com/basic-emacs/>

## Lessons
### Clojure
- Anonymous function (lambda) cannot be nested.
- If processing a list, and each element is another list (so, nested list), write separated function to map: (map process_each list)
- Java function must be wrapped (map #(Integer/parse %) list)
- Use Clojure 1.11 with new function parse-long instead of using Java function.
- Order is not persistent as in Elixir, (map fun collections) but (clojure.string/split string #"regex"), thus it is hard to use thread macro (->> s f1 f2) to pass result as last argument. Thus have to use (as-> s x (f1 x) (f2 x)) to specify order of x. BUT [this](https://stackoverflow.com/questions/50275513/rules-of-thumb-for-function-arguments-ordering-in-clojure) explain why. TLDR: "Sequence functions take their sources last and collection functions take their primary operand (collection) first.". Thus, if only first one split string take diff order, use it as first function in thread, the rest all follow the rule of processing sequences. (->> (string.split s #" ") (map f) (filter f))
- Map can be used as function to get value from key (mymap mykey)
- To destructure (unpack), use (let [[a b] '(1 2 3) (println a b)]), a = 1 and b = 2, note the [a b] must be []. Ref <https://gist.github.com/john2x/e1dca953548bfdfb9844>

#### Clojure errors
The most common errors and how to fix:

- `class XXX cannot be cast to class YYY`: function expects type YYY but got arg type XXX, often wrong argument orders. A function that work on String oftens take String as first argument.
  ```clj
  > (clojure.string/split #" " "abcd")
  Execution error (ClassCastException) at clj2022.core/eval13230 (form-init12478536996561014764.clj:671).
  class java.lang.String cannot be cast to class java.util.regex.Pattern (java.lang.String and java.util.regex.Pattern are in module java.base of loader 'bootstrap')
  ```
- `class XXX cannot be cast to class clojure.lang.IFn`: call XXX as function, often redundant () , or used C-like function call.

```clj
> ((+ 1 2))
Execution error (ClassCastException) ..
class java.lang.Long cannot be cast to class clojure.lang.IFn

> (clojure.string/split("abc", #"b"))
Execution error ...
class java.lang.String cannot be cast to class clojure.lang.IFn
```

### Emacs
- Use mouse choose on menubar > CIDER interaction / CIDER eval menus if not familiar with shortcut yet.
- Use C-c C-k to evaluated current file (emacs called buffer).
- Use M-x cider-format-buffer to format current file
- Run test: open the test file, eval by C-c C-k then run test under cursor: C-c C-t t
- Run all tests in file: C-c C-t n
- Put the function want to run to the last line, result will be shown after evaluated, this is like click "Run" buttons on IDE.

#### Paredit.el
Paredit is a "minor mode" in Emacs, for the most simple usage, it helps auto-close parenthesis. If you type `(`, it will auto add `)`.

install : M-x package-install then type `paredit`.

To enable/disable: type M-x paredit

- Type (, to add the expression after it to inside (), type C-→  (called slurp)
- To remove latest expression before ), type C-← (called barf).

Ref: <https://www.braveclojure.com/basic-emacs/#Paredit>


