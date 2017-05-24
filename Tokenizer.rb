require_relative './model/Core'
=begin
NOTES ON PROGRAM
Written by Obinna U Ngini. First ruby program try(not counting hello world script)
Program splits file line by line, and then splits each line by whitespace.
The function tokenize is then called
on each word to split it into tokens according to the Core syntax
Each token is then evaluated, and the corresponding value is printed to the console
=end

class Tokenizer

  def initialize
    @all_tokens = []
    @token_values = []
    @curr_token = 0
    @tot_tkn_count = 0
  end

  def numeric?(char)
    char =~ /[0-9]/
  end

  def letter?(char)
    char =~ /[A-Za-z]/
  end

  def upper_case?(char)
    char =~ /[A-Z]/
  end

  module States
    ERROR = 0.freeze
    LETTER = 1.freeze
    DIGIT = 2.freeze
    SYMBOL = 3.freeze
  end
  States.freeze

  def tokenize(input)
    Array tokens = []
    token_count = 0
    tkn = ''
    state = States::LETTER # letter is starting position
    for i in 0..input.length - 1
      char = input[i]
      added_symbol = false
      if state == States::ERROR
        # Keep collecting characters until a symbol is found
        if !Core.symbol?(char)
          tkn << char
          state = States::ERROR
        else
          state = States::SYMBOL
        end
      end
      if state == States::LETTER # collecting letter
        # Keep collecting letters while in this state
        if letter?(char)
          tkn << char
          state = States::LETTER
        # Change to digit collection state if a digit is seen
        elsif numeric?(char)
          state = States::DIGIT
        # Change to symbol collection state
        elsif Core.symbol?(char)
          # If there is a non empty token, add to array of tokens
          if tkn != ''
            tokens[token_count] = tkn
            token_count += 1
          end
          tkn = char
          state = States::SYMBOL
          added_symbol = true
        end
      end
      if state == States::DIGIT # collecting digits
        # Go to error state if letter comes after digit
        if letter?(char)
          tkn << char
          state = States::ERROR
        elsif numeric?(char)
          state = 2
          tkn << char
        elsif Core.symbol?(char)
          tokens[token_count] = tkn
          token_count += 1
          tkn = char
          state = States::SYMBOL
          added_symbol = true
        end
      end
      if state == States::SYMBOL # collecting symbols
        # Fix bug to enable this not add blank to the array
        if letter?(char)
          tokens[token_count] = tkn
          token_count += 1
          tkn = char
          state = States::LETTER
        elsif numeric?(char)
          tokens[token_count] = tkn
          token_count += 1
          tkn = char
          state = States::DIGIT
        elsif Core.symbol?(char)
            if char == '=' && tkn.length == 1 && !added_symbol && symbol_can_precedes_equals?(tkn[0])
              tkn << char
              state = States::SYMBOL
            elsif char == '&' && tkn[0] == '&'
              tkn << char unless added_symbol
            elsif char == '|' && tkn[0] == '|'
              tkn << char unless added_symbol
            elsif !added_symbol
              tokens[token_count] = tkn
              token_count += 1
              tkn = char
            elsif added_symbol
              tkn = char
            else
              state = States::ERROR
            end
        end
      end
    end
    # add the last stuff to the array if state is not ERROR
    tokens[token_count] = tkn if state != States::ERROR
    return tokens
  end

  def symbol_can_precedes_equals?(char)
    return char == '>' || char == '<' || char == '!' || char == '='
  end

  def eval_token(input)
    x = 0
    if Core.keyword?(input)
      x = Core.keyword_val(input)
    elsif number?(input)
      x = Core::NUMBER
    elsif identifier?(input)
      x = Core::IDENTIFIER
    else
      x = Core::ERROR
    end
    return x
  end

  def number?(input)
    # Make sure input forms a number
    flag = false
    for i in 0..input.length - 1
      char = input[i]
      if numeric?(char)
        flag = true
      else
        flag = false
        break
      end
    end
    return flag
  end

  def identifier?(input)
    # Make sure identifier is all caps letters and numbers and numbers only come at the end
    state = upper_case?(input[0]) ? States::LETTER : States::ERROR
    for i in 0..input.length - 1
      char = input[i]
      if state == States::LETTER # collecting letter
        if upper_case?(char)
          state = States::LETTER
        elsif numeric?(char)
          state = States::DIGIT
        end
      end
      if state == States::DIGIT # collecting digits
        if upper_case?(char)
          state = States::ERROR
          break
        elsif numeric?(char)
          state = States::DIGIT
        end
      end
    end
    return state != States::ERROR
  end

  def skip_token
    flag = false
    if @curr_token < @tot_tkn_count - 1
      @curr_token += 1
      flag = true
    end
    return flag
  end

  def get_token
    return @all_tokens[@curr_token]
  end

  def print_tokens
    @all_tokens.each do |token|
      puts token
    end
  end

  def print_token_values
    @token_values.each do |token|
      puts token
    end
  end

  def write_tokens_to_file(fname)
    File.open(fname, 'w') do |file|
      @token_values.each do |token|
        file.puts token
      end
    end
  end

  def tokenize_file(fname)
    exists = false
    if File.file?(fname)
      exists = true
      File.open(fname, 'r').each do |line|
        Array temp = line.split
        temp.each do |word|
          Array tokens = tokenize(word)
          tokens.each do |token|
            @all_tokens[@tot_tkn_count] = token
            value = eval_token(token)
            @token_values[@tot_tkn_count] = value
            @tot_tkn_count += 1
            if value == Core::ERROR
              puts "Error token #{token} found! Invalid Core Program."
              Process.exit!
            end
            # puts "token: #{token} value: #{value}"
          end
        end
      end
      # write EOF
      @token_values[@tot_tkn_count] = Core::EOF
    end
    return exists
  end

  def main 
    if ARGV[0]
      fname = ARGV[0]
    else
      print 'Please enter the filename: '
      fname = gets.chomp
    end
    if tokenize_file(fname)
      print_token_values
      file_path = File.expand_path(File.join(File.dirname(__FILE__), 'output', 'tokenized.txt'))
      write_tokens_to_file(file_path)
    else
      puts "File #{fname} does not exist!"
    end
  end
end

class TokenizerRunner
  def run
    Tokenizer.new.main
  end
  TokenizerRunner.new.run
end
