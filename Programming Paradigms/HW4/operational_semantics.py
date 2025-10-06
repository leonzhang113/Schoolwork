import sys

class ParseTree:
    def __init__(self,root,children):
        self.root = root # A string with the symbol name
        self.children = children # List: Each element a ParseTree or a String for leaves

# Assume tree is valid parse tree
def translate_prod_file(tree):
    ids = first_pass(tree)
    tmp = translate_prod_list(tree.children[0],7, ids)
    return "\n".join(["0  stack = EmptyStack",
                      "1  x = 0",
                      "2  y = 0",
                      "3  push 5 to stack",
                      "4  goto line " + str(ids["main"]),
                      "5  print_without_newline(x)",
                      "6  halt",
                      tmp[0]])

def translate_prod_list(tree,line,ids):
    val, ln = translate_prod(tree.children[0], line, ids)
    if len(tree.children) > 1:
        val2, ln = translate_prod_list(tree.children[2], ln, ids)
        val = val + "\n" + val2
    return (val, ln)

def translate_prod(tree,line, ids):
    body,ln = translate_body(tree.children[2],line,ids)
    body = body + "\n" + str(ln) + "  tmp = pop from stack\n" + str(ln+1) + "  goto line in tmp"
    return (body,ln+2)

def translate_body(tree,line,ids):
    val,ln = translate_body_item(tree.children[0], line,ids)
    if len(tree.children) > 1:
        val2,ln = translate_body(tree.children[2], ln, ids)
        val = val + "\n" + val2
    return (val, ln)

def translate_body_item(tree, line,ids):
    if tree.children[0] == "&":
          return (str(line) + "  x = x + 1", line+1)
    elif tree.children[0] == "*":
          return (str(line) + "  print_without_newline(x)\n" + str(line+1) + "  print_without_newline(' ')",line+2)
    elif tree.children[0] == "%":
        return (str(line) + "  push y to stack\n" + str(line+1) + "  y = x\n" + str(line+2) + "  x = pop from stack", line+3)
    else: # Must be an ID
          return (str(line) + "  push " + str(line+2) + " to stack\n" + str(line+1) + "  goto line " + str(ids[tree.children[0]]), line+2)

def first_pass(tree):
    ids = {}
    tmp = first_pass_prod_list(tree.children[0],7, ids)
    return ids

def first_pass_prod_list(tree,line,ids):
    ln = first_pass_prod(tree.children[0], line, ids)
    if len(tree.children) > 1:
        ln = first_pass_prod_list(tree.children[2], ln, ids)
    return ln

def first_pass_prod(tree,line, ids):
    ids[tree.children[0]] = line
    ln = first_pass_body(tree.children[2],line)
    return ln+2

def first_pass_body(tree,line):
    ln = first_pass_body_item(tree.children[0], line)
    if len(tree.children) > 1:
        ln = first_pass_body(tree.children[2], ln)
    return ln

def first_pass_body_item(tree, line):
    if tree.children[0] == "&":
        return line+1
    elif tree.children[0] == "*":
        return line+2
    elif tree.children[0] == "%":
        return line+3
    else: # Must be an ID
        return line+2

####################################################################################
# Not part of the operational semantics
# You may Ignore this part
# It provides a Lexer and Parser

class Lexer:
    def __init__(self,input):
        self.input = input
        self.index = 0

    def peek(self):
        i = self.index
        tk = self.lex()
        self.index = i
        return tk

    def done(self):
        return self.index >= len(self.input)

    def lex(self):
        while self.index < len(self.input) and self.input[self.index].isspace() and self.input[self.index] != "\n":
            self.index = self.index + 1
        if self.index < len(self.input):
            match self.input[self.index]:
                case "\n":
                    self.index = self.index + 1
                    return "ENDLINE"
                case "&" | "*" | "%" | ",":
                    self.index = self.index + 1
                    return self.input[self.index-1]
                case "-":
                    self.index = self.index + 1
                    if self.index < len(self.input) and self.input[self.index] == ">":
                        self.index = self.index + 1
                        return "->"
                    else:
                        raise ValueError("Expected '>' after '-'")
                case _:
                    s = self.index
                    while self.index < len(self.input) and self.input[self.index].isalnum():
                        self.index = self.index+1
                    return ["".join(self.input[s:self.index])]
        else:
            return True

class Parser:
    def __init__(self,input):
        self.lexer = Lexer(input)
    def parse(self):
        return ParseTree("<prod_file>", [self.parse_prod_list()])
    def parse_prod_list(self):
        c = [self.parse_prod()]
        if self.lexer.lex() == "ENDLINE":
            c.append("ENDLINE")
            c.append(self.parse_prod_list())
        return ParseTree("<prod_list>", c)
    def parse_prod(self):
        id = self.lexer.lex()
        if type(id) is list:
            if self.lexer.lex() == "->":
              return ParseTree("<prod>", [id[0], "->", self.parse_body()])
            else:
                raise ValueError("<prod>: " + id[0] + " missing '->'")
        else:
            raise ValueError("Expected id but got '" + str(id) + "'")
    def parse_body(self):
        bi = self.parse_body_item()
        match self.lexer.peek():
            case ",":
                self.lexer.lex()
                return ParseTree("<body", [bi, ",", self.parse_body()])
            case "ENDLINE" | True:
                return ParseTree("<body>", [bi])
            case _:
                raise ValueError("<body> Expected ',' or ENDLINE")
    def parse_body_item(self):
        tk = self.lexer.lex()
        match tk:
            case "ENDLINE" | "," | "->":
                raise ValueError("<body_item> Unexpecte ',', '->', or ENDLINE")
            case _:
                if type(tk) is list:
                  return ParseTree("<body_item>", [tk[0]])
                else:
                  return ParseTree("<body_item>", [tk])
####################################################################################

with open(sys.argv[1]) as f:
  parser = Parser(list(f.read().strip()))
prog = parser.parse()
if prog != False:
    print("\n\n")
    print(translate_prod_file(prog))
    print("\n\n")
