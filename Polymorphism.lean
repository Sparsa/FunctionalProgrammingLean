-- polymorphic version of point
structure PPoint (α : Type) where -- Type is a type that describe other types so ℕ, List, String etc. are all
          x: α
          y: α
deriving Repr

-- we can use ℕ to define an origin using the PPoint
def NatOrigin : PPoint Nat:=
    {x := ( 0:Nat ), y:= ( 0:Nat )}

inductive Sign where
          | pos
          | neg

def posOrNegthree (s: Sign) : match s with | Sign.pos => Nat | Sign.neg =>  Int :=
    match s with
          | Sign.pos => (3:Nat)
          | Sign.neg => (3:Int)
-- Linked list in Lean (L^3)
def primesUnder10 : List Nat := [2,3,5,7]
-- Now I remember the difference between inductive and structure., recall that the List is an Inductive data type.
def explicitPrimesUnder10 : List Nat :=
    List.cons 2 (List.cons 3 ( List.cons 5 (List.cons 7 List.nil) ))
def length (α : Type) (xs : List α) : Nat :=
    match xs with
    | List.nil => Nat.zero
    | List.cons y ys => Nat.succ (length α ys)
-- In most languages the compler is perfectly capable enough of determining type arguments on its own, and only occisionally needs help from users. This is also the case in Lean
#eval primesUnder10.length
--- More built in data types.
-- Option
--
-- This is similar to what Maybe is for haskell
-- it is defined as inductinve
inductive OOption (α : Type ): Type where
          | none : OOption α
          | some (val:α):OOption α

-- to find the head of the list use the following function List.head?
-- note the ? mark after the head, this basically tells us that the head can be empty
-- so it returns the Option type and we have to use the constructor to get the value out
--
def LList.head? {α: Type} (xs:List α) : Option  α :=
    match xs with
    | [] => none
    | y:: _ => some y
-- Naming convention in Lean
-- head requries the called to provide mathematical evidence that the list is notempty
-- head? returns an option,
-- head! crashes the program when passed an empty list and
-- headD taeks a default value to return in case the lsit is empty.
#eval primesUnder10.head?
#eval [].head? -- this is bcause Lean was unable to fully determine the expression's type.
-- the lean compiler does not know the empty list have a type or not. or it can not derive it from the element of the list, so it is our reponsibility to provide lean with the type
-- There are some variables in lean that holds these basic as you will see in the error message markes as ?m. these are called meta variables
#eval [].head? (α := Int)
#eval ([] : List Int).head?
-- Prod
-- Prod or product structure is a generic way of joining two values together.
-- prod nat String will create a product of natural number and string
-- the prod is defined as shown below
structure PPProd (α : Type) (β : Type) : Type where
          fst : α
          snd : β
def fives : String × Int := {fst := "five", snd:=5}
#eval fives

-- Sum datatype
-- Sum is just linke or. that is why it has an inductive
inductive SSum (α : Type) (β : Type) : Type where
          | inl : α → SSum α β
          | inr : α → SSum α β
def PetName : Type := String ⊕ String

def animals : List PetName :=
    [Sum.inl "Spot", Sum.inr "Tiger", Sum.inl "Fifi", Sum.inl "Rex", Sum.inr "Floof"]
#eval animals
def howManyDogs (pets: List PetName) : Nat :=
    match pets with
    | [] => 0
    |Sum.inl _ :: morePets => howManyDogs morePets + 1
    |Sum.inr _ :: morePets => howManyDogs morePets

#eval howManyDogs animals

-- Unit type:
-- this is a type with just one argumentless constructor called unit.
-- In other words, it describes only a single value, which conssites of said constructore applied to no arguments whatsoever. Unit is defined as follows;
inductive UUnit:Type where
          |unit : UUnit
inductive ArithExpr (ann: Type):Type where
| int : ann → Int → ArithExpr ann
| plus : ann → ArithExpr ann → ArithExpr ann → ArithExpr ann
| minus : ann → ArithExpr ann → ArithExpr ann → ArithExpr ann
| times : ann → ArithExpr ann → ArithExpr ann → ArithExpr ann
-- every functions in lean requires arguments, so if you want to define a function with no arguements you can use unit as an argument
-- the unit type is very similar to the void type in c class of programming language    s
-- Empty datatype
-- Empty data type has no constructors whatsoever.
-- Thus, it indicates unreachable code
--  it is not used as often as Unit but it isuseful in some specialized contexts many polymorphic datatypes do not use all of their type arguments in all of their constructors.
--  Naming : Sus, Products and Units
--  Types that offer multiple constructors are called sum types,
--  Types whose single constructor takes multiple arguments are calld product types.
--  Not all definable structures or inductive types can have the type `Type`
inductive MyType : Type where
          | ctor : (α : Type) → α → MyType
-- Exercises:
-- Write a function to find the last entry in a list It should return Option
def lastOfList? {α: Type} (xs: List α) : Option α :=
    match xs with
    | [] => none
    | y :: [] => some y
    | y :: ys => lastOfList? ys
#eval lastOfList? animals
-- Write a function that finds the first entry in a list that satisfies a given predicate
def List.findFirst? {α : Type} (xs : List α)
(predicate : α → Bool) : Option α :=
           match xs with
           | [] => none
           | y :: ys => match (predicate y) with
                       | true => some y
                       | false => List.findFirst? ys predicate

-- Write a function Prod.swap that swaps the fields in a pair
def Prod.swap {α β : Type} (pair : α × β ) : β × α := (pair.snd,pair.fst)
-- Rewrite the PetName example to use a custom datatype and compare it to the version that uses Sum
--
-- Write a function zip that combines two lists into a list of pairs. The resulting list should be as long
-- as the shortest input list
-- Start the definition with d
def zip {α β : Type} (xs: List α) (ys : List β)  : List (α × β) :=
    match xs with
    | [] => []
    | x :: xxs => match ys with
                  | [] => []
                  | y::yys => List.cons (x,y) (zip xxs yys)

#eval zip animals animals
-- define a polymorphic function take that returns the first n entries in a list where n is Nat
def take {α : Type} (n : Nat) (xs : List α) : List α :=
    match n with
    | 0 => []
    | Nat.succ n => match xs with
                    | [] => []
                    | y::ys => List.cons y (take n ys)
#eval take 6 animals

-- Using the anlogy between types and arithmatic, write a function that distributes producs over
-- sums. In other words, it should have type `α × (β⊕γ) → (α × β) ⊕ (α × γ)`

def distributive {α β γ : Type} (v:(α × (β ⊕ γ))) :  ((α × β) ⊕ (α × γ))  :=
    match v.snd with
       | Sum.inl b => Sum.inl ( v.fst,  b)
       | Sum.inr g => Sum.inr (v.fst , g)

def distribute_product_over_sum {α β γ : Type} (a : α ×( β ⊕ γ)) : (α × β) ⊕ (α × γ) :=
  match a.snd with
  | Sum.inl b' => Sum.inl (a.fst, b')
  | Sum.inr c' => Sum.inr (a.fst, c')
-- Using the analogy between type and arithmatic, write a function that turns multiplication
-- by two into a sum
def mul_to_sum {α : Type} ( a: Bool × α ) : (α ⊕ α) :=
    match a.fst with
    | true => Sum.inl a.snd
    | false => Sum.inr a.snd
-- solving the same using if then else construct :P
def double_as_sum {α : Type} (a : Bool× α) : α ⊕ α :=
  if a.fst then Sum.inr a.snd else Sum.inl a.snd
