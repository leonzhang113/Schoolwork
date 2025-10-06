README

In the Makefile folder, change the following lines to desired input files.

run: input.txt


input.txt: all
        $(JAVA) -cp $(CP) LexerTest input.txt > input-output.txt
        cat input.txt
        cat -n input-output.txt

In the terminal, navigate to the project folder. Run $make or $make run. 
