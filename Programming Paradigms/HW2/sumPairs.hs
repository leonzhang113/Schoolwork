sumPairs :: [Int] -> [Int]
sumPairs [] = [] --Case where input list is empty
sumPairs [x] = [x] --Case where there is only one element in the list
sumPairs (x:y:restOfList) = (x + y) : sumPairs restOfList --General case, sums first two elements, and recursively calls with rest of list
