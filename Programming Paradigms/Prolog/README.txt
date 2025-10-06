README

Included Files:
sample_runs - includes test cases to run the main program on and also includes the expected output.
shift-planner.pl - Prolog file that is used to create the shifts.
testing.pl - testing file to run various tests on the schedules made to find variours errors
README.txt - text file explaning purpose of each file and how to run the programs.
Write-up - word document explaining my project process, things I learned, and features I did not complete.

How to Run:
First, you must have Prolog installed on your computer as well as a an environment that can run Prolog code, most common is
SWI-Prolog. When running the program in terminal, make sure you are in the correct directory to access both the sample_runs and
the main programs. Once the swipl command is ran, there will be a ?- prompt. Type in the following:
?- consult('example-input-#').
?- consult('shift-planner').
?- consult('testing').

Once they are verified, running plan(Plan). will generate a viable schedule. Pressing spacebar will keep generating lists
while Enter will stop and let you run various test commands from the testing file. 
EX:
?- plan(Plan),no_work(Plan,_).
?- plan(Plan),double_work(Plan,_).
?- plan(Plan),works_at(Plan,_,ophelia,1).