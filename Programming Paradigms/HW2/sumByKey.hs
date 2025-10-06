sumByKey :: [(Int, Int)] -> Either String (Int, Int)
sumByKey pairs = sumByKeyTail pairs (0, 0) where --call tail recursive function
  sumByKeyTail :: [(Int, Int)] -> (Int, Int) -> Either String (Int, Int) --input is a list of tuples, output is either a tuple or an error message
  sumByKeyTail [] acc = Right acc --base case when list is empty, return accumulator value
  sumByKeyTail ((key, value):xs) (sum0, sum1) 
    | key == 0  = sumByKeyTail xs (sum0 + value, sum1) --if the key is a 0, add the value to the current total of sum0
    | key == 1  = sumByKeyTail xs (sum0, sum1 + value) --if the key is 1, add value to the current total of sum1
    | otherwise = Left $ "Invalid key: " ++ show key  --if the key is not 0/1, then there is an invalid key, display the incorrect value
