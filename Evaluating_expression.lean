#eval 1+2
#eval 1 + 2 * 5
#eval String.append "Hello, " "Lean!"
#eval String.append "Great " (String.append "Oak" "Tree")
#eval String.append "It is " (if 1 > 2 then "yes" else "NO")
#eval 42 + 19
#eval String.append "A" (String.append "B" "C")
#eval String.append (String.append "A" "B") "C"
#eval if 3 ==3  then 5 else 7
#eval if 3==4 then "equal" else "Not equal"

-- types in lean programming
#eval (1+2:Nat)
-- Nat stands for natural numbers which are arbitrary precision unsigned
-- integers. In lean Nat is the default type for non-negative integer literals.
-- Nat can represent arbitrary long number Unline C.
#eval 1 - 2
-- When you substract a bigger value then Nat doesnt overflow and returns 0
#eval (1-2:Int)
-- But this type will return -1 as expected.
#check (1-2:Int)

--Can we check if we can append an array with a string? #check String.append
--"hello" [" ", "World"] clearly the above check will fail saying that it is
--trying to append the string type with the list type. Functions and definitions
--
def hello := "Hello"
def lean : String := "Lean"
#eval String.append hello (String.append " " lean)
-- Just like any programming languages the name defined previously can be used
-- later after the definitions. Unlinke other programming languages the
-- definition of function and any other definitions are all defined using `def`
-- keyword one simple way of defining functions is
def add1 (n:Nat) : Nat := n + 1
-- It starts with the `def` keyword, then name of the function then, the
-- arguments with their types and then the return type of the function finally
-- after the `:=` the main function definition.
#eval add1 7

def maximum (n:Nat) (k:Nat) : Nat :=
    if n < k then
       k
    else n

#eval maximum (5+8) (2*7)
#check (maximum)

--Behind the scenes, all functions actually expect precisely one argumen
-- remember the currying. Exercise Define the function joinStringsWith with type
-- String -> String -> String -> String that creates a new string by placing its
-- first argument between its second and third arguments. joinStringsWith ", "
-- "one" "and another" should evaluate to "one, and another".
def joinStringsWith (s m n : String) :String :=
    String.append m (String.append s n)

#eval joinStringsWith ", " "One" "and another"
-- What is the type of `joinStringsWith` ": "? Check your answe with Lean
#check joinStringsWith ": "
-- joinStringsWith ": " : String → String → String Define a function `volume`
-- with type `Nat -> Nat -> Nat -> Nat` that computes the volume of a
-- rectangular prism with the given height, width, and depth
def volume (height width depth : Nat) : Nat :=
    height * width * depth
-- Most typed programming languages have some means of defining aliases for types,
-- such as C's typedef. In lean howeer types are a first-clas part of the language
-- they are expressions like any other. This means that definiions can refer to types
-- just as well a they cna refer to other values.
-- Example:
def str: Type := String
-- Note that we have defined a new emelent of the type `Type`
-- And then assigned it to be same as string

def aStr : str := "This is a string"
-- this works because types are also expressions in LEan.
-- You can similarly define NaturalNumbers instead of Nat
def NaturalNumber : Type := Nat
-- but when you try to create a new element of the type NaturalNumber and define
-- a value def thirtyEight :NaturalNumger := 38 for numbers this will not work
-- becuase number types are polymorphic becuase of thier different uses in
-- diffrent branches of mathematics So, the part of code that allows this new
-- type, can not change all part required for the polymorhpishm, thus this
-- expression will have error One way to work around this issue is the let the
-- Lean know which number you are expressing when you are saying 38. Here we are
-- thinking of 38 :Nat
def thirtyEight : NaturalNumber := (38 : Nat)
-- using `abbrev` instead of `def` while defining the types resolves this issue
abbrev N:Type := Nat
def thirtyNine : N := 39 -- this works
--
-- Behind the scenes some definitions are internally marked as begin unfoldabl
-- during overload resolution. While others are not. Defntions that are to be
-- unfolded are called `reducible`. Control over reducibility is esseitial to
-- ally lean to scale. Fully unfolding all definitions can result in very large
-- types that are slow for a machine to process and diffcult for uers to
-- understand. Definitions produced with `abbrev` are marked as reducible.
