Prefix Calculator README

README.txt - Gives instructions on how to compile and run this program. Also gives additional info about the program and some
	of the input instructions as well as errors that may occur.

Write-up.doc - Goes over my approach to the project and its overall organization and an explanation for both. It also explains in detail
	various problems I encountered as well as solutions and general insight on what I learned throughout the project.

prefixCalculate.hs - Haskell program that allows users to input a prefix expression and will evaluate the expression. It also
	saves a history of previous results and allows users to reference them in expressions.

How to Compile and Run 
Compiling: Open a Haskell Compiler, if you don't have one, you can go to this website https://www.haskell.org/downloads/
	and follow instructions to install one. Once in the compiler, make sure you are in the same directory that contains the
	prefixCalculator.hs file, this can be done through various cd commands through the terminal. Then, run the command 
	'ghc prefixCalculator.hs' which will compile the code and create 3 files: prefixCalculator.exe, .hi, and .o. 
	Once it is compiled, type the command './prefixCalculator' to start the program.

Running the Program: Once the program is executed, it will prompt the user with the message:
	"Enter your expression in prefix notation, please separate numbers with spaces. Enter '0' to exit: "
	The program allows the following operations: +, *, /, in order to subtract, you can use the unary operator '-' to add 
	a negative number (ex: + -3 4). The program will then validate the input to make sure it is in proper prefix notation 
	and if it is not, then it will keep prompting the user for inputs until it gets a valid expression. 
	After it evaluates an expression, it will prompt the user again and will keep doing so until the user enters '0' to exit
	the program. 

Additional Info: Each run of the program keeps a history of results from previous expressions. The output will display the ID of each
	result, which can be referenced to by the user in future inputs. This can be done by using '$n' in your expression, the 'n' 
	representing the id of the result you are trying to reference from the history. For example, if a result = 6 and had an ID
	of 4, it could be referenced using $4. 
	WARNING: referencing an ID that has not been created yet will cause an error and shut down the program. 
	Exiting the program will get rid of the history values and start with an empty list. 
