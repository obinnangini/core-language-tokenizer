module Core
    SYMBOLS = [';', ',', '=', '!', '[', ']', '&', '|', '(', ')', '+', '-', '*', '>', '<']
    KEYWORDS = {
    'program' => 1,
    'begin' => 2,
    'end' => 3,
    'int' => 4,
    'if' => 5,
    'then' => 6,
    'else' => 7,
    'while' => 8,
    'loop' => 9,
    'read' => 10,
    'write' => 11,
    ';' => 12,
    ',' => 13,
    '=' => 14,
    '!' => 15,
    '[' => 16,
    ']' => 17,
    '&&' => 18,
    '||' => 19,
    '(' => 20,
    ')' => 21,
    '+' => 22,
    '-' => 23,
    '*' => 24,
    '!=' => 25,
    '==' => 26,
    '<' => 27,
    '>' => 28,
    '<=' => 29,
    '>=' => 30
    }
    NUMBER = 31
    IDENTIFIER = 32
    EOF = 33
    ERROR = 35

    def Core.isSymbol?(token)
        return SYMBOLS.include?(token)
    end

    def Core.isKeyword?(token)
        return KEYWORDS.key?(token)
    end

    def Core.getKeywordValue(token)
        return KEYWORDS[token]
    end
  end