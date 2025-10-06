import java.util.Random;

public class MutationFuzzer {

    static final String OPERATORS = "+-*/";
    static final String NUMBERS = "123456789";
    static final Random random = new Random();

    private static String generateRandomValidInfixExpression(int length) {
        StringBuilder expression = new StringBuilder();
        for (int i = 0; i < length; i++) {
            if(i % 2 == 0)
                expression.append(NUMBERS.charAt(random.nextInt(NUMBERS.length())));
            else 
                expression.append(OPERATORS.charAt(random.nextInt(OPERATORS.length())));
        }
        if(!Character.isDigit(expression.charAt(length - 1))){
            expression.append(NUMBERS.charAt(random.nextInt(NUMBERS.length() - 1)));
        }
        return expression.toString();
    }
    
    //Mutate an existing infix expression
    private static String mutateInfixExpression(String expression) {
        int mutationPoint = random.nextInt(expression.length());
        char mutationChar = random.nextBoolean() ? OPERATORS.charAt(random.nextInt(OPERATORS.length())) 
                                                  : NUMBERS.charAt(random.nextInt(NUMBERS.length()));
        return expression.substring(0, mutationPoint) + mutationChar + expression.substring(mutationPoint + 1);
    }

    public static void main(String[] args) {
        String expressions [] = new String [5];

        //generates random valid infix expressions, acts as "existing data"
        for (int i = 0; i < expressions.length; i++) {
            int randomLength = random.nextInt(5) + 5;
            expressions[i] = generateRandomValidInfixExpression(randomLength);
            String postfix = PostfixEvaluator.infixToPostfix(expressions[i]);
            System.out.println("Postfix: " + postfix);
            double val = PostfixEvaluator.evaluatePostfix(postfix);
            System.out.println("Value: " + val);

            //runs the same test but with the valid expression ran through a mutator method
            expressions[i] = mutateInfixExpression(expressions[i]);
            System.out.println("\nValues After Mutating:");
            postfix = PostfixEvaluator.infixToPostfix(expressions[i]); 
            System.out.println("Postfix: " + postfix);
            val = PostfixEvaluator.evaluatePostfix(postfix);
            System.out.println("Value: " + val);
            System.out.println("__________________________________\n");
        }

    }
}