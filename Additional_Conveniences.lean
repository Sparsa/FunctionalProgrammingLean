-- When writing polymorphic functions in Lean, it is typically not necessary to list all the implicit
-- arguments. Instead they can simply be mentioned. If lean can determine their type then they are
-- automatically inserted as implicit arguments.
--
def length  (xs : List α) : Nat :=
    match xs with
    | [] => 0
    | y:: ys => Nat.succ (length ys)

-- Pattern matching definitions
-- If you are planning to use the arguments in the pattern matching using match
-- then you do not have to write the match `argument` with every time,
def lenght : List α → Nat -- note that we aere skipping :=
    | [] => 0 -- note that we are directly writing the pattern matching
    | y :: ys => Nat.succ (length ys)
-- This can also be done using multiple parameters, in this case each parameters will be written
-- separated by a comma
def drop : Nat → List α → List α
    | Nat.zero, xs => xs
    | _, [] => []
    | Nat.succ n, x::xs => drop n xs
def take : Nat → List α → List α
    | Nat.zero, _ => []
    | _, [] => []
    | Nat.succ n, x::xs => List.cons x (take n xs)
def animals : List String :=
    ["Spot",  "Tiger", "Fifi", "Rex", "Floof"]
#eval take 2 animals
-- A function that takes a default value and an optional value, and returnsthe default when
-- the optional alue is none
def fromOption (default : α) : Option α → α
    | none => default
    | some x => x
-- this function returns a default value if the option is none
-- else it returns the some value
-- This function is defined in the lean standard library as Option.getD (or you can say get `D`efault)
#eval (some "salmonberry").getD ""
#eval none.getD "" -- note that this function takes an option element and an default element
--- Local definitions
-- Creating a temporary object to hold a temporary solution, is good
-- If you are using an expression multiple times, then using the same expression several time uses
-- more computation power.
def unzip : List (α × β) → List α × List β
    | [] => ([],[])
    | (x,y) :: xys => (x::(unzip xys).fst,y::(unzip xys).snd)
-- clearly it is recomputing the `(unzip xys)` twice, this will create an exponential growth
def unzipo : List (α × β ) → List α × List β
    | [] => ([],[])
    | (x,y) :: xys =>
    let unzipped : List α × List β := unzipo xys;    (x::unzipped.fst,y::unzipped.snd)
-- you can replace ; in the previous line with a return

-- What are the differences between def and let?
-- The biggest difference between def and let is: if you are defining a recursive definition
-- using let then you need to explicitely add the keyword rec after let
def reverse (xs : List α) : List α :=
    let rec helper : List α → List α → List α -- the helper is a local recursive
                                              -- function and the definition
                                              -- follows
        | [], soFar => soFar
        | y :: ys, soFar => helper ys (y::soFar)
    helper xs []
