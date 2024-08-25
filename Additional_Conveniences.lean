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
-- Type infrence Due to leans power of deriving types, some of the type
-- declarations can be omitted from the definition
def unzipd : List (α × β) → List α × List β
    | [] => ([],[])
    | (x,y) :: xys =>
      let unzipped := unzipd xys
      (x :: unzipped.fst , y :: unzipped.snd)
-- here we are not declaring the types, the types are assumed
-- Omitting the return type for `unzip` is possible when using an explicit `match` expression:
def unzipp (pairs : List (α × β)) :=
    match pairs with
    | [] => ([],[])
    | (x,y) :: xys =>
      let unzipped := unzip xys
      (x::unzipped.fst,y::unzipped.snd)
-- Generally speaking it is a good idea to err on the side of too many, rather
-- than too few, type annotations. First off ,xplicit types communicates
-- assumptions about the code to readers Secondly, explicit types help localize
-- errors. Thirdly, explicit types make it easier to write the program in the
-- first place. the compilers feedback can be helpful tool in writing a progra
-- that meets the speification. Finally, Lean's type infrences is a best-effort
-- system. ecause Lean's typesystem is so expressive, there is no best or most
-- general ltype to e find for all expressions. Even if you get a type that
-- doesnot guarantee that it's the right type for a given application
-- for instance, 14 can be a Nat or an Int.
#check 14
#check (14:Nat)
--Missing type annotations can give confusing error messages, omitting all types
-- from the definition of unzip Simultaneious matching Patternmatching
-- expressions, just like the patternmatching definitions can match on
-- multiplevalues at onee Both the expresions to be inspected and the patterns
-- that they match against are written with commas between them, similarly to
-- the syntax used for definitions
def dropp (n:Nat) (xs : List α) : List α :=
    match n, xs with
    | Nat.zero, ys => ys
    | _, [] => []
    | Nat.succ n, y ::ys => dropp n ys
#eval dropp 2 [1,2,3,4,5]

-- simple patterns There is a special syntax to make list patterns ore readable
-- than using List.cons and List.nil directly
-- natural numbers can be matched using lteral numbers and +.
-- for instance even can also be defined like this.
def even (n:Nat) : Bool :=
    match n with
    |     Nat.zero => true
    |     Nat.succ k => not (even k)
def even2 : Nat → Bool
    | 0 => true
    | n + 1 => not (even2 n)

#eval even2 3
#eval even 3
-- Anynymous function
-- you can define anonymous function using the fun keyword in lean
#check fun x => x +x
-- you can also define a anonymous function using the `.` notation wrapped with a function
-- for example the function `fun x => x + 1` can be writtein as `(. + 1)`
#eval (.+5,3) 2 -- the `.` is replaced with 2, and this creates a tuple with the value (7,3).
-- Namespace
namespace NewNamespace
def triple (x:Nat) : Nat := 3*x
def quadruple (x: Nat) : Nat := 2 * x + 2*x
end NewNamespace

#check NewNamespace.triple
#check NewNamespace.quadruple

-- If let When consuming values that have a sum type, it is often the case that
-- only a single constructor is of interest
inductive Inline : Type where
          | lineBreak
          | string : String → Inline
          | emph: Inline → Inline
          | strong : Inline → Inline
-- A function that recognizes string elements and extracts their contents can be written
--def Inline.string? (inline : Inlnie) : Option String :=
--match inline with
--| Inline.string s => some s
--| _ => none

-- This is very much like the pattern-matching `let`
def Inline.string? (inline:Inline) : Option String :=
if let Inline.string s := inline then
   some s
else none

-- Positional structure arguments In some contexts it can be convenient to pass
-- arguments positionally, rather than by name, but without naming the
-- constructor directly. for instance defining a variety of similar structure
-- types can help keep domain concepts seprate, but the natural way to read the
-- code may treat each of them as being essentially a tuple.
--
-- In these contexts the arguments can be enclosed in angle ⟨⟩

#eval ( ⟨1,2⟩: Point )
-- String interpolation In lean a prefixing a string with s! triggers
-- interpolatin, where expressions contained in curly braces inside the string
-- are replaced with their values.
--
#eval s!"Three five is {NewNamespace.triple 5}"

-- Not all expressions can be interpolated into a string. For instance,
-- atteptiong to interpolate a function results in an error
#check s!"Three fives is {NewNamespace.triple}"
-- Theres no standard wayto convert a function to a string the lean copiler
-- maintains a table that describes how to convert values of various types into
-- strings, and the message failed to synthesize instane means that the lean
-- compiler didnt find an entry in this table for the given type this uses the
-- same language feature as the deriving repr syntax that was descibed in the
-- section on strucutres
