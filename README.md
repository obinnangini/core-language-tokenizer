# Core Language Tokenizer

First ruby program try(not counting hello world script)

## Tokenizer 
The Tokenizer takes input from a provided file and splits the program into tokens based on the valid Core program syntax. The main function goes through the file line by line and passes words to the tokenize function, which splits up the word and returns an array of valid tokens to the main function to be evaluated.

## Core BNF
See the syntax for the CORE Language [here](/docs/core-bnf.md)

## How it works
The Tokenizer class begins in the “collecting letters” and cycles to the “collecting digits” phase or “collecting symbol” phase based on the characters in the word. The tokenizer also checks that the token being built character by character is classified according to the Core syntax. It calls another function, called evaltoken, to evaluate the token generated and return the value of the token. If a token is found to be an error token, the program will print a message to the user informing them of the error and will then immediately terminate.

## Running the Program
To use the Tokenizer, provide a file containing a core program as input. The filename can be entered in student Linux or C command prompt (if Ruby is installed on the machine) in the format “ruby tokenizer.rb (filename)” or entered as input by typing “ruby tokenizer.rb” and providing the name at the prompt. The values of the resulting tokens will then be printed to the console.

## Test Cases
The Tokenizer was tested using the test cases as well as some error cases to ensure it terminated when encountering an error token. It gave correct results for all cases and there are no bugs to report.

## Change Log
1. First pass(and what was submitted for assigment) can be found at archive/tokenizer.rb
1. Second (and current) cleaned up logging and merged in fixes made in the Tokenizer class copied into the Interpreter.rb. Added functionality to print results to output directory
