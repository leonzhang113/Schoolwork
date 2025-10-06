range :: Int -> Int -> [Int]
range x y
  | x > y     = []
  | x == y    = [y]
  | otherwise = x : range (x+1) y

main :: IO ()
main = do
  putStrLn "Enter two integers:"
  input <- getLine
  let [x, y] = map read (words input)
  putStrLn $ "Range from " ++ show x ++ " to " ++ show y ++ ":"
  print $ range x y