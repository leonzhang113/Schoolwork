removeVowels :: String -> String
removeVowels = filter (\char -> notElem char "AEIOUaeiou") -- use elem function to check if current character is in a list of vowels


