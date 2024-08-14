-- Defining a structure introduces a completely new type to lean that can't be
-- reduced to any othe type This is useful becasue multiple structures might
-- represent different concpets that nonetheless contain the same data. For
-- instance, a point might be represented using either Cartesian or polar
-- co-ordinates. Each pair of floating point numbers Defining separate
-- structures prevents API clients fro confusing one for another
#check 1.2
#check -454.2123215
#check 0.0
-- for lean to detect if a number is floating point or not without any decimal
-- point, it is necessary to provide the type annotation
#check 0
#check (0:Float)

-- Let us define a cartesian point using structure
structure Point where
          x: Float
          y: Float
deriving Repr -- This is asking Lean to provide the code to display Typical way
-- to create a value of a structure type is to provide values for all of its
-- field inside of curly braces
def origin : Point := {x := 0.0, y:=0.0}
-- Updating structure
def zeroX (p:Point) : Point :=
    {x := 0, y:=p.y} -- note that we are assingning the 0 value to x and using
-- p.y to get value from p this will create a new Structure object with x value
-- 0 and y value equal to p. this can be problematic if your structure have to
-- many elements to update, then you might miss some
-- To solve this issue, Lean allows you `with` directive
def zeroX2 (p:Point) : Point :=
    {p with x :=0} -- this tells that the new object will copy p but will
                   -- replace the value of x with 0
def fourAndThree : Point :=
{x:= 4.3, y:=3.4}
#eval fourAndThree
#eval zeroX fourAndThree
#eval fourAndThree
-- clearly the update is creating a new object and not overriting the existing one.
-- By default the constructor is named lie <name of the structure>.mk
#check Point.mk 1.5 3.8

-- Constructors have function types, that means that they can be used anywhere
-- that a function is expected
#check (Point.mk)
-- one can override this constructor name, using two colons `::` for example
structure Point2 where
          point:: -- when you are using this you are basically naing the constructor `point`
          x: Float
          y: Float
deriving Repr
-- in addition to the constructor, an accessor function is defined for each field of a structure.
-- These have the same name as the field e.g., for structure Point and for the element x
#check (Point.x)
-- The curly braced structure construction syntax is converted to a call to the
-- strucutures constructor behind the scenes, the syntax `p1.x` in the prior
-- definition of add points is converted into a call to the `Point.x` Accessor
-- `dot` notation is usable with more than just structure fields. It can be used
-- for functions that take any number of arguents. More generally, accessor
-- notation has the form `Target.f Arg1 Arg2..` if target has type T
#eval "One String".append " and another"

def Point.modifyBoth (f: Float → Float) (p: Point) : Point :=
    { x:= f p.x, y:= f p.y }
-- this function takes a function that changes a float to anothe float and another point
-- Then it creates a new object of the structure where the x and y members of the new strucutre
-- is changed using the function
#eval fourAndThree.modifyBoth Float.floor
-- Note that the function is defined in Point namespace and the point is expected as the secoond
-- argument, but it can be used using the dot notation after the object
-- that is why when you are calling the function from an object it understands that you are passing
-- that object as the second argument.
-- Exercise 1: Define a structure `RectangularPrism` that contains the height, width, and depth of
-- a rectangular prism as Float.
structure RectangularPrism where
          height : Float
          width : Float
          depth : Float
deriving Repr
-- Exercise 2: Define a function named volume: RectangularPrism → Float. That
-- computes the volume of a rectangular prism
def RectangularPrism.volume (Rp: RectangularPrism) : Float :=
    Rp.height * Rp.width *Rp.depth
-- Exercise 3: Define a structure named `Segement` that represents a line
-- segment by its endpoints, and define a function length: Segment → Float that
-- computes the length of a line segment. Segment should have at most two fields
structure Segment where
          x1 : Point
          x2 : Point
deriving Repr
def Segment.length (line : Segment) : Float :=
    Float.sqrt ((line.x1.x - line.x2.x )^2+(line.x1.y - line.x2.y)^2)

def P:Segment := {x1 := origin, x2:= fourAndThree}
#eval P.length
-- Exercise 4: what names are introduced by the declartion of RectangularPrism?
-- height, width, depth and volume, and mk (the default constructor). Exercise 5: What names are introduced by the
-- following declarations of Haster and Book? what are their types?
structure Hamster where
          name: String
          fluffy: Bool

structure Book where
          makeBook::
          title : String
          author : String
          price : Float
#check (Book.makeBook)
-- As discussed in the previous exercise, the names defined are the fields
-- (name, fluffy) with types (String, Bool) respectively it also have the `mk`
-- as constructor. for the book structure `makeBook` is the constructor of type
-- String → String → Float → Book. Then the fields are, Book.title : String,
-- Book.author: String, Book.price : Float
--
