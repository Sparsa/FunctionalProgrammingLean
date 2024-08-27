def main : IO Unit := IO.println "Hello, World!"
-- run this file using the command `lean --run Hello.lean`
--
-- Functional programming vs effects: The result of evaluating an expression
-- does not change, and evaluating the same expression again will always yield
-- the same result useful programs must interact with the world. A program that
-- performs neigher input nor output can't ask a user for data, create files on
-- disk
def main2 : IO Unit := do
-- local definition in a let can be used in just one expression, which immideately follows the local definition. In a `do` block local bindings introduced by let are available in all statement in the remainder of the do block, rather than the next one.
    let stdin ← IO.getStdin
    let stdout ← IO.getStdout
-- Additionally, let typically connects the name being defined to its definition using `:=`
-- while osme let bindings in do use a left arrow (← )
-- using an arrow means that the value of the xpression is an IO action, that should be executed, whith the result of the action saved in the localvariableIN other ords if the expresion to the right of the arow has type IO α then variable has type
-- α in the reainder of the do block.
    stdout.putStrLn "How would you like to be addressed?"
    let input ← stdin.getLine
    let name := input.dropRightWhile Char.isWhitespace

    stdout.putStrLn s!"Hello, {name}"
-- why are we differentiating the between evaluating expressions and executing io actions?
-- Separating evaluation from execution means that programsmust be explicit about which funcions can have side effects.
-- The parts of the the program that do not have effects are much more amenable to mathematical reasoning. Whereas, in the heads of programmers or using leans facilities for fomral proof, theis separationcan make it easier to avoid bugs.
-- Not all IO actions need be executed at the time that they come into existence. The ability to mention an action without carrying it out allows ordinary functions to be used as control structures.
def twice (action : IO Unit) : IO Unit := do
    action
    action

#eval twice (IO.println "Shy")

-- this can be generalized to a version that runs the underlying action any number of times
def nTimes (action: IO Unit) : Nat → IO Unit
    | 0 => pure () -- Die funktion `pure` erstellt ein IO aktion
    -- mit kein effekt, arber
    | n + 1 => do
      action
      nTimes action n
#eval nTimes (IO.println "Hello") 3

-- IO actions are first-clas values means that they can be saved in data structures for later execution.
-- For instance th e function countdown takes a Nat and reurns a list of unexecuted IO actions.
def countdown : Nat → List (IO Unit)
    | 0 => [IO.println "Blas Off!"]
    | n + 1 => IO.println s!"{n+1}" :: countdown n
def form5 : List (IO Unit) := countdown 5
#eval form5.length

-- The function runActions takes a list o actions and constru acts a single action that runs them all in order:
def runActions : List (IO Unit) → IO Unit
    | [] => pure ()
    | act :: actions => do
      act
      runActions actions
#eval runActions form5
