# fuzzy

Fuzzy string search in Haskell. Uses `Data.TextualMonoid`
from [monoid-subclasses](https://hackage.haskell.org/package/monoid-subclasses)
to be able to run on different types of strings.

Ported from the JavaScript equivalent [mattyork/fuzzy](https://github.com/mattyork/fuzzy).

## Usage

```haskell

> import Text.Fuzzy

> match "fnt" "infinite" "" "" id True
Just ("infinite",3)

> match "hsk" ("Haskell",1995) "<" ">" fst False
Just ("<h>a<s><k>ell",5)

> filter "ML" [("Standard ML", 1990),("OCaml",1996),("Scala",2003)] "<" ">" fst False
[Fuzzy {original = ("Standard ML",1990), rendered = "standard <m><l>", score = 4},Fuzzy {original = ("OCaml",1996), rendered = "oca<m><l>", score = 4}]

> simpleFilter "vm" ["vim", "emacs", "virtual machine"]
["vim","virtual machine"]

> test "brd" "bread"
True
```

## License

MIT
