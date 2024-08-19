-- Structures enable multiple independent pieces of data to be combined into a
-- coherent whole that is represented by a brand new type. Types such as structures that group together, these collection of values are called `product types` many domain concepts, can't be naturally represented as structures. Many applcation requries arbitrary number of elements unline the fixed elements that is provided by the structure. This is why we need recursive structures like tree or lists. Data types that allows choices are called `sum types` and data types that contains instances of themselves are called `recursive datatypes`. Recursive `sum types` are called `inductive datatypes`, beause mathematical induction may be used to prove statements aout them. when programming inductinve datatypes are consumed through pattern matching and recursive functions
--
inductive Bool where -- this line provides the name of the inductive type
          | false : Bool -- each of these remaining lines are constructors.
          | true : Bool -- Clearly unlike structures inductive data types can have multiple constructors
-- Anothe inductive definition is of Nat
inductive Nat1 where
          | zero : Nat1
          | succ (n : Nat1) : Nat1
-- Lean datatype consructors are much more like  subclasses of an abstract class than they are like constructors in C# or Java.
-- Pattern matching

def isZero (n :Nat) : Bool :=
    match n with
    | Nat.zero => True
    | Nat.succ k => False
#eval isZero (Nat.zero)
#eval isZero (5)
#eval Nat.pred 5
#eval Nat.pred 0 -- becuase Nat can not represent negative numbers, pred of 0 is mapped to itself.

-- we can write the pred function based using match.
def pred1 (n:Nat1) : Nat1 :=
    match n with
    | Nat1.zero => Nat1.zero -- mapping pred of  0 to itself
    | Nat1.succ k => k -- if there is a succ structure then we will map it to the underlying integer.
-- Note that pattern matching can be used on both structures as well as with sum types.
structure Point3D where
          x : Float
          y : Float
          z : Float

def depth (p: Point3D) : Float :=
    match p with
    | {x := h, y := w , z := d} => d
-- this pattern matching basically takes a object of Point3D and then checks if the values of its members atches with the name or not
-- Recyrsuve Functions:
def even (n: Nat) :Bool :=
    match n with
    | Nat.zero => true -- the zero is by default even
    | Nat.succ k => not (even k) -- successor of an odd is even, thus if succ k is even then k must be odd.
    -- this is a nice example of structural induction
def plus (n k : Nat) : Nat :=
    match k with
    | Nat.zero => n
    | Nat.succ k' => Nat.succ (plus n k')
def times (n k : Nat) : Nat :=
    match k with
    | Nat.zero => Nat.zero
    | Nat.succ k' => plus n (times n k')
def minus (n k : Nat) : Nat :=
    match k with
    | Nat.zero => n
    | Nat.succ k' => Nat.pred (minus n k')
def div (n k : Nat) : Nat := -- Lean can not automatically gurantee the terination of this algo this doesnt mean that this program is non-terminating, rather we have to provide proper proofs to lean so that it doesnnot complain.
    if n < k then
       0
    else Nat.succ (div (n-k) k)
