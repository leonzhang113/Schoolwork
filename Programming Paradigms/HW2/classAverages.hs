type Student = (Int, Int, Int, Int) --(exams, hw, projects, quizzes)

studentAverage :: Student -> Double --function that gives weighted grade for each student
studentAverage (ex, hw, pr, qu) =
    fromIntegral (ex * 30 + hw * 30 + pr * 30 + qu * 10) / 100

classAverages :: [Student] -> [Double]
classAverages = map studentAverage --map student average function to each student in the class
