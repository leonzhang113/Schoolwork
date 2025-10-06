import Data.Char

--main loop to control logic of the program. The program will continue to prompt users for expressions until they type '0'. The
--results of each expression is saved in a history list that users can reference in future prompts.
mainLoop :: [Int] -> IO ()
mainLoop history = do
    input <- inputLoop
    if input == "0"
        then putStr "Exiting Calculator..."
    else do
        updatedHistory <- evalPrefix (tokenize input) history --allows the history to be updated with each new input
        mainLoop updatedHistory
    

--function to loop through getting user input until it is valid input. This is so don't have to error check during actual
--prefix evaluation 
inputLoop :: IO String
inputLoop = do
    expression <- enterExpression
    if validateInput expression && validatePrefix expression
        then do
        return expression
        else do
            if expression == "0"
                then do 
                    return "0"
            else do putStrLn "Invalid Expression, please try again: "
                    inputLoop

--function to get the prefix input from the user
enterExpression :: IO String
enterExpression = do
    print "Enter your expression in prefix notation, please separate numbers with spaces. Enter '0' to exit: "
    getLine

--function to tokenize input to allow for easier string manipulation
tokenize :: String -> [String]
tokenize [] = []
tokenize (c:cs)
    | c == ' ' = tokenize cs --skips over spaces, necessary for separting numbers
    | c == '$' = let (num, rest) = span isDigit cs in ('$' : num) : tokenize rest --puts $n in its own token
    | c == '-' = let (num, rest) = span isDigit cs in ('-' : num) : tokenize rest --puts -n in its own token
    | isDigit c = let (num, rest) = span isDigit (c:cs) in num : tokenize rest --tokens numbers
    | otherwise = [c] : tokenize cs --else it is a symbol 

--function to validate user input to make sure there's no unallowed symbols and that there are at least 3 elements in the expression
--this function does not validate if the express is in proper prefix notation
validateInput :: String -> Bool
validateInput = all allowedSymbols
    where
        allowedSymbols c = isDigit c || isSpace c || c `elem` "+-*/$"

--Validate prefix method takes the user input and tokenizes it. Returns false if it fails to pass 4 conditions of 
--a prefix expression: 1. it has at least 3 elements, 2. there is one more operand than operator, 3. the last two elements
--in a prefix expression have to be numbersm and 4. first element has to be an operator
validatePrefix :: String -> Bool
validatePrefix input =
    let tokens = tokenize input
    in length tokens >= 3 &&   --checks if there are at least 3 elements
       (length (filter isOperand tokens) == length (filter isOperator tokens) + 1) && --checks if there is 1 more operand than operator 
       all isOperand (take 2 $ reverse tokens) &&    --reverse the tokens to get the first two (last two elements)
       isOperator (head tokens) --checks if the first element is an operator

--recursive function to evaluate prefix expressions
--steps for prefix evaluation: 1. Point to end of list (stack)
evalPrefix :: [String] -> [Int] -> IO [Int]
evalPrefix tokens history = 
  let (result, _, updatedHistory) = eval (reverse tokens) [] history
      newHistory = result : updatedHistory -- Use cons to add the result to the history
  in do
      putStrLn ("= " ++ show result ++ " | History ID: " ++ show (length newHistory))
      return newHistory
      
--recursive function to evaluate prefix
{-Steps: 2. if token is an operand, push it to the stack/list
         3. if operator, pop top two elements and apply the operator and push result to the stack
         4. continue as long as there are elements in the input left
         5. return answer
-}
eval :: [String] -> [Int] -> [Int] -> (Int, [String], [Int]) --takes in the input, result stack, and history list
eval [] stack history = (head stack, [], history) --base case when input list is empty, returns the final value of the stack
eval (token:tokens) stack history 
    | hasDollar token =                                        -- case where if the operand is a reference to a history element
        case hasIndex history (read (tail token) - 1) of       -- have to check if the history id is valid, does it exist
            Just histValue -> eval tokens (histValue:stack) history  --if it does exist, calls eval again with the value in its place
            Nothing -> error "Invalid Expression"             --if it doesn't exist, output error
    | isOperand token = eval tokens (read token : stack) history --if operand, 'push' to top of the stack
    | isOperator token =                                        --if operator, 'pop' top two elements and apply operator to them
        let (x:y:restStack) = stack
            opResult = applyOp token x y
        in eval tokens (opResult:restStack) history             --push result to top of the stack

--helper method to check if the history id index exists in the history list
hasIndex :: [a] -> Int -> Maybe a
hasIndex [] _ = Nothing -- if history list is empty
hasIndex (x:xs) n       -- recursively checks through the list to see if the element exists
    | n == 0    = Just x  
    | n > 0     = hasIndex xs (n - 1)
    | otherwise = Nothing

--helper function to apply the operation
--no case for '-' because it is a unary operator, case handled in the + when adding a negative number
applyOp :: String -> Int -> Int -> Int
applyOp "+" x y = x + y
applyOp "*" x y = x * y
applyOp "/" x y = x `div` y

--helper function to check if a token is a reference to a history id, checks for '$'
hasDollar :: String -> Bool
hasDollar ('$':xs) = True
hasDollar _       = False

--helper function to check if a token is an operand
isOperand :: [Char] -> Bool
isOperand token = case token of
      ('$':xs) -> all isDigit xs --case 1, the token has a $ 
      ('-':xs) -> all isDigit xs --case 2, the token has a -
      xs -> all isDigit xs

--helper function to check if a token is an oeprator
isOperator :: [Char] -> Bool
isOperator token = token `elem` ["+", "*", "/"]

--main function
main = do
    mainLoop []

