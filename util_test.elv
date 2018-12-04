use github.com/zzamboni/elvish-modules/test
use github.com/zzamboni/elvish-modules/util

(test:set github.com/zzamboni/elvish-modules/util [
    (test:set dotify-string [
        (test:is { util:dotify-string "somelongstring" 5 } "somel…" Long string gets dotified)
        (test:is { util:dotify-string "short" 5 }          "short"  Equal-as-limit string stays the same)
        (test:is { util:dotify-string "bah" 5 }            "bah"    Short string stays the same)
    ])
    (test:set pipesplit [
        (test:is { put [(util:pipesplit { echo stdout; echo stderr >&2 } { echo STDOUT: (cat) } { echo STDERR: (cat) } | sort)] } ["STDERR: stderr" "STDOUT: stdout"] Parallel redirection)
    ])
    (test:set eval [
        (test:is { util:eval "echo yes" } yes Evaluated code)
    ])
    (test:set max-min [
        (test:is { util:max 1 2 3 -1 5 0 }  5 Maximum)
        (test:is { util:min 1 2 3 -1 5 0 } -1 Minimum)
        (test:is { util:max a bc def ghijkl &with=$count~ } ghijkl Maximum with function)
        (test:is { util:min a bc def ghijkl &with=$count~ } a Minimum with function)
    ])
    (test:set cond [
        (test:is { util:cond [ $false no $true yes ] }                  yes   Conditional with constant test)
        (test:is { util:cond [ $false no { eq 1 1 } yes ] }             yes   Conditional with function test)
        (test:is { util:cond [ $false no { eq 0 1 } yes :else final ] } final Default option with :else)
        (test:is { put [(util:cond [ $false no ])] }                    []    No conditions match, no output)
        (test:is { put [(util:cond [ ])] }                              []    Empty conditions, no output)
        (test:is { util:cond [ { eq 1 1 } $eq~ ] }                      $eq~  Return value is a function)
    ])
    (test:set optional-input [
        (test:is { util:optional-input [foo bar] }         [foo bar]     Input from list)
        (test:is { put foo bar baz | util:optional-input } [foo bar baz] Input from pipeline)
        (test:is { util:optional-input }                   []            Empty input)
    ])
    (test:set select-and-remove [
        (test:is { put [(util:select [n]{ eq $n 0 } [ 3 2 0 2 -1 ])] } [0]        Select zeros from a list)
        (test:is { put [(util:remove [n]{ eq $n 0 } [ 3 2 0 2 -1 ])] } [3 2 2 -1] Remove zeros from a list)
    ])
    (test:set partial [
        (test:is { (util:partial $+~ 3) 5 }                       8     Partial addition)
        (test:is { (util:partial $eq~ 3) 3 }                      $true Partial eq)
        (test:is { (util:partial [@args]{ * $@args } 1 2) 3 4 5 } 120   Partial custom function with rest arg)
    ])
])
