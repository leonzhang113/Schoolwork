import java.util.Stack;
import java.util.Scanner;

public class PostfixEvaluator {

	public static void main(String[] args) {
		// Check number of arguments passed
		Scanner in = new Scanner(System.in);
		System.out.print("Enter expression: " );
		String infix = in.nextLine();
	    if (infix.length() == 0) {
	      System.out.println(
	        "Usage: java EvaluateExpression \"expression\"");
	      System.exit(1);
	    }
	    try {
	    	System.out.println(evaluatePostfix(infixToPostfix((infix))));
	     }
	      catch (Exception ex) {
	    	  System.out.println("Wrong expression: " + infix);
	     }
	    
	}
	
	public static String infixToPostfix(String infix) {
		System.out.println("Infix: " + infix);
		//Stack that temporarily holds values
		Stack <String> tempStack = new Stack<>();
		
		 // Extract operands and operators from infix string
		String[] tokens = insertBlanks(infix).split(" ");
		
		String postfix = " ";
		
		//for loop that goes through the infix string 
		for(int i = 0; i < tokens.length; i++) {
			
			//make sure that any stray spaces do not cause error
			if(tokens[i].length() != 0) {
				
				//if condition checks if the index is on a '+', '-', '*', or '/'
				if(tokens[i].charAt(0) == '+' || (tokens[i].length() < 2 && tokens[i].charAt(0) == '-') || //makes sure the minus is an operator and not a negatvie number
					tokens[i].charAt(0) == '*' || tokens[i].charAt(0)== '/') {
					//while loop that will print all operators already in the stack with higher precedence than the current operator
					while(!tempStack.isEmpty() && operatorPrecedence(tempStack.peek().charAt(0)) >= 
												  operatorPrecedence(tokens[i].charAt(0))) {
						postfix += tempStack.pop() + " "; //adds the operators with higher precedence onto the postfix string
					}
					tempStack.push(tokens[i]);  //pushes the current operator into the stack
				}
				
				else if(tokens[i].charAt(0) == '(') { //if index is on a '(', then push it into the stack
					tempStack.push(tokens[i]);
				}
				
				else if(tokens[i].charAt(0) == ')') { //check if index is on a ')' 
					
					String temp = tempStack.pop(); //if so, set a temp string to the ')'
					
					while(!temp.equals("(")){ //while loop set to run until the tempStack hits a '(''
						postfix += temp + " ";      //this will output all operators until it reaches the '('
						temp = tempStack.pop();
					}	
				}
				else {
					postfix += tokens[i] + " "; //if index is not pointing to operator or '(,)' outputs an operand
				}
			}
		}
		for(int j = 0; j <= tempStack.size(); j++) { //goes through the stack for the remaining operators and outputs
			postfix += tempStack.pop() + " ";				//them into the output
		}
					
		return postfix; //returns the postfix output
	}
	
	//method that assigns each operator a "value" of precedence, the higher value, the higher precedence, needed to easily
	//see when an operator should be popped
	public static int operatorPrecedence(char operand) {
		if(operand == '+' || operand == '-') {
			return 1; // '+' and '-' have a lower precedence so set to 1
		}
		else if(operand == '*' || operand == '/' ) { // '*' and '-' have higher precedence so set to 2
			return 2;
		}	
		return 0; //all non operators do not need precedence
	}
	
	//method to evaluate the postfix expression
	public static double evaluatePostfix(String postfix) {
		//Stack to hold the operands
		Stack <Double> operandStack = new Stack<>(); //stack for holding the operands

		Double result = 0.0;
	
		//tokenize the postfix string to separate the operands and operators, use substring of postfix because of space
		//at beginning of string
		String [] tokens = postfix.substring(1,postfix.length()).split(" ");
		
		//for loop to go through the token array to evaluate the postfix expression
		for(int i = 0; i < tokens.length; i++) {
			//if condition checks if the stack is empty and if the index of tokens is == to an operator
			if(!operandStack.isEmpty() && (tokens[i].charAt(0) == '+' || (tokens[i].length() < 2 && tokens[i].charAt(0) == '-') ||
			   tokens[i].charAt(0) == '*' || tokens[i].charAt(0) == '/')) {
			   
				//if index is at an operator, pop the top two values of the stack and calculate them
				double b = operandStack.pop();
				double a = operandStack.pop();
				//push the calculated value into the stack
				operandStack.push(calculate(tokens[i], a, b));	
			}
			else {
				//if index is at an operand then push it into stack
				operandStack.push(Double.parseDouble(tokens[i])); 
			}
		}
		//for loop should run until only one value left which is the result of the postfix evaluation, pop value into result
		result = operandStack.pop();
		return result;
	}
	
	//separate method for doing calculations
	public static double calculate(String operator, double a, double b) {
		
		if(operator.equals("+")) { //returns addition of the two popped numbers
			return a + b;
		}
		else if(operator.equals("-")) { //returns subtraction of the two popped numbers
			return a - b;
		}
		else if(operator.equals("*")) { //returns multiplication of the two popped numbers
			return a * b;
		}
		else { //returns division of the two popped numbers
			return a/b;			
		}
	}
	
	//method to split the arguments
	public static String insertBlanks(String s) {
	    String result = "";
	    
	    for (int i = 0; i < s.length(); i++) {
	      if (s.charAt(i) == '(' || s.charAt(i) == ')' || 
	          s.charAt(i) == '+' || s.charAt(i) == '-' ||
	          s.charAt(i) == '*' || s.charAt(i) == '/')
	        result += " " + s.charAt(i) + " ";
	      else
	        result += s.charAt(i);
	    }
	    
	    /* the given insert blank method works for everything except negative numbers, so have to check whether
	     * a given negative sign is an operator or negative number. Not sure if I just utilized this section of code
	     * incorrectly or if this was intended.
	     */
	    //this for loop checks for double spaces caused by operations following paranthesis such as ) * and gets 
	    //rid of them 
	    for(int i = 0; i < result.length()-1; i++) {
	    	if(result.length() > 1 && result.charAt(i) == ' ' && result.charAt(i+1) == ' ') {
	    		result = result.substring(0,i) + result.substring(i+1,result.length());
	    	}
	    }
	    
	    //this for loop checks for 2 different negative signs. 
	    for(int i = 0; i < result.length(); i++) {
	    	
	    	//if the first given number is a negative number, then the negative sign should be in the first index of
	    	//the result string (not the 0 index because of the space put in front of operators) if the first index
	    	//holds a negative number, gets rid of the space between the negative sign and its corresponding number
	    	if(result.length() > 1 && result.charAt(1) == '-') {
	    		result = result.substring(1,2) + result.substring(3,result.length());
	    	}
	    	
	    	//this if statement checks for the rest of the negative numbers, if the index i is on a negative sign, will
	    	//compare if the value at the index i-2 (2 because of the space between values) and see if it is a number.
	    	//If it is not, then know the value at i-2 is an operator, and any operator followed by a negative sign means
	    	// the next number is negative ie: 3 + 8 * - 4 should actually be 3 + 8 * -4
	    	else if(result.charAt(i) == '-' && !Character.isDigit(result.charAt(i-2)) && 
	    			(result.charAt(i-2) != ')' || result.charAt(i-2) != '(')) {
	    		result = result.substring(0,i+1) + result.substring(i+2,result.length());
	    	}
	    }
	    
	    if(result.length() > 0 && result.charAt(1) == '(') { //gets rid of the extra spaces at the beginning and end
	    	result = result.substring(1, result.length());   //of the result string
	    }
	    return result;
	  }

}
