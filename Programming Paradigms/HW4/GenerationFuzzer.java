import java.util.Random;

public class GenerationFuzzer {

    static final String OPERATORS = "+-*/";
    static final String NUMBERS = "0123456789";
    static final Random random = new Random();

    //More complex and handles wider variety of cases compared to the mutation fuzzer. This allows the program
    //to check more edge cases. Still want to input what would be considered valid expressions, although they may
    //contain redundant information ex: 3 +              (((((4 + 3))))) is still a valid expression.
    public static String generateRandomValidInfixExpression(int length) {
        StringBuilder expression = new StringBuilder();
        int openParentheses = 0;

        for (int i = 0; i < length; i++) {
            if (random.nextBoolean()) {
                expression.append(" ");
            }
            if (i % 2 == 0) {
                if (random.nextBoolean() && openParentheses < (length - i) / 2) { 
                    //insert random number of parentheses
                    int randParenthesis = random.nextInt(5) + 1;
                    for(int j = 0; j < random.nextInt(randParenthesis); j++){
                        expression.append("(");
                        openParentheses++;
                    }      
                }
                expression.append(NUMBERS.charAt(random.nextInt(NUMBERS.length())));
                //randomly close parenthesis
                if (openParentheses > 0 && random.nextBoolean() && Character.isDigit(expression.charAt(expression.length() - 1))) {
                    expression.append(")");
                    openParentheses--;
                }
            } 
            else {
                expression.append(OPERATORS.charAt(random.nextInt(OPERATORS.length())));   
            }
        }
        //Checks if last char is a digit, and if not, then add a digit to end
        if (!Character.isDigit(expression.charAt(expression.length() - 1)) && expression.charAt(expression.length() - 1) != ')') {
            expression.append(NUMBERS.charAt(random.nextInt(NUMBERS.length())));
        }
         //Close any remaining open parentheses
         for (int i = 0; i < openParentheses; i++) {
            expression.append(")");
        }

        return expression.toString();
    }
    public static void main(String[] args) {
        String expressions [] = new String [5];

        //generates random valid infix expressions
        for (int i = 0; i < expressions.length; i++) {
            int randomLength = random.nextInt(5) + 5;
            expressions[i] = generateRandomValidInfixExpression(randomLength);
            String postfix = PostfixEvaluator.infixToPostfix(expressions[i]);
            System.out.println("Postfix: " + postfix);
            double val = PostfixEvaluator.evaluatePostfix(postfix);
            System.out.println("Value: " + val);

        }

    }
}