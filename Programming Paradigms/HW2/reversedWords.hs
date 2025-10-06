reversedWords :: String -> [String]
reversedWords = map reverse . words -- . used to compose the functions map reverse and words, the words function splits input into
-- separate words, and the map reverse applies reverse to each separate word.
