class Tokenizer
  
  Array $alltokens = Array.new
  Array $tokenValues = Array.new
    $curr_token = 0
    $tot_tkn_count = 0
    $keywords = {
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
    '>=' => 30,
    }

    $symbols = [';', ',', '=', '!', '[', ']', '&', '|', '(', ')', '+', '-', '*', '>', '<']

  def numeric?(lookAhead)
    lookAhead =~ /[0-9]/
  end

  def letter?(lookAhead)
    lookAhead =~ /[A-Za-z]/
  end

  def capletter?(lookAhead)
    lookAhead =~ /[A-Z]/
  end
  
  def tokenize(input)
    Array tokens = Array.new
    token_count = 0
    tkn = ""
    state = 1 #letter is starting postition
    for x in 0..input.length-1
      added_symbol = false
      if state == 0 #error
        #Keep collecting characters until a symbol is found
        if not $symbols.include?(input[x])
          tkn<<input[x]
          state = 0
        else
          state = 3
        end
      end
      if state == 1#collecting letter
        #Keep collecting letters while in this state
        if letter?(input[x])
          tkn<<input[x]
          state = 1
        #Change to digit collection state if a digit is seen
        elsif numeric?(input[x])
          state = 2
        #Change to symbol collection state
        elsif $symbols.include?(input[x])
          #If there is a non empty token, add to array of tokens
          if not tkn == ""
            tokens[token_count] = tkn
            token_count = token_count + 1
          end
          tkn = input[x]
          state = 3
          added_symbol = true
        end
      end
      if state == 2 # collecting digits
        #Go to error state if letter comes after digit
        if letter?(input[x])
          tkn<<input[x]
          state = 0
        elsif numeric?(input[x])
          state = 2
          tkn<<input[x]
        elsif $symbols.include?(input[x])
          tokens[token_count] = tkn
          token_count = token_count + 1
          tkn = input[x]
          state = 3
          added_symbol = true
        end
      end
      if state == 3 #collecting symbols
        #Fix bug to enable this not add blank to the array
        if letter?(input[x])
          tokens[token_count] = tkn
          token_count = token_count + 1
          tkn = input[x]
          state = 1
        elsif numeric?(input[x])
          tokens[token_count] = tkn
          token_count = token_count + 1
          tkn = input[x]
          state = 2
        elsif $symbols.include?(input[x])
          if ((input[x] == '=') and (tkn.length == 1) and (added_symbol == false) and (tkn[0] == '>' or tkn[0] == '<' or tkn[0] == '!' or tkn[0] == '='))             
            tkn<<input[x]
            state = 3
          elsif input[x] == '&' and  tkn[tkn.length - 2] ==  '&'
            if added_symbol == false
              tkn<<input[x]
            end
          elsif input[x] == '|' and  tkn[tkn.length - 2] ==  '|'
            if added_symbol == false
              tkn<<input[x]
            end
          elsif added_symbol == false
            tokens[token_count] = tkn
            token_count = token_count + 1
            tkn = input[x]
          elsif added_symbol == true
            tkn = input[x]
          else 
            state = 0
          end
        end
      end
    end

    #add the last stuff to the array if not state == 0
    if (not state == 0)
      tokens[token_count] = tkn
      tkn = ""
    #else
    # puts"Warning: Illegal token #{tkn}" 
    end
    #simple token test
    #tokens.each do |test|
    # puts test
    return tokens 
  end

  def evaltoken(input)
    #Evaluate the token, getting the hashmap value if it is a keyword
    x = 0
    if $keywords.key?(input)
      x = $keywords[input]
    #Else check if it is a number
    elsif number?(input)
      x = 31
    #Else check if it is an identifier
    elsif (not identifier?(input) == 0)
      x = 32
    else
    # Else token is an error token
      x = 35
    end
    return x
  end


  def number?(input)
    #Make sure input forms a number
    x = 0
    flag = false
    for x in 0..input.length-1
      if numeric?(input[x])
        flag = true
      else
        flag = false
        break
      end 
    end
    return flag
  end

  def identifier?(input)
    #Make sure identifier is all caps letters and numbers and numbers only come at the end
    flag = true
    state = 0
    if capletter?(input[0])
      state = 1
    end
    for x in 0..input.length-1
      if state == 1#collecting letter
        if capletter?(input[x])
          state = 1
        elsif numeric?(input[x])
          state = 2
        end
      end
      if state == 2#collecting digits
        if capletter?(input[x])
          flag = false
          state = 0
          break
        elsif numeric?(input[x])
          state = 2
        end
      end
    end
    return state
  end

  def skiptoken
    flag = false
    if $curr_token < $tot_tkn_count -1
      $curr_token = $curr_token + 1
      flag = true
    end
    return flag
  end

  def gettoken
    return $alltokens[$curr_token]
  end

  def gettokens 
    return $alltokens
  end

  def gettokenValues 
    return $tokenValues
  end

  def printtokens
    $alltokens.each do |token|
      puts token
    end
  end

  def printtokenValues
    $tokenValues.each do |token|
      puts token
    end
  end

  def writeTokensToFile(fname)
    File.open(fname, 'w') do |f|
      $tokenValues.each do |token|
        f.puts token
      end
    end
  end

  def tokenizefile(fname)
    exists = false
    if File.file?(fname)
      exists = true
      File.open(fname, 'r').each do |line|
        Array temp = line.split()
        temp.each do |word|
          Array tokens =  tokenize(word)
          tokens.each do |token|  
            $alltokens[$tot_tkn_count] = token
            value = evaltoken(token)
            $tokenValues[$tot_tkn_count] = value
            $tot_tkn_count = $tot_tkn_count + 1
            if value == 35
              puts "Error token #{token} found! This is an invalid Core Program."
              Process.exit!()
            end
            #puts "token:#{token} value:#{value}"
          end
        end
      end
      #write 33 to file at the end
      $tokenValues[$tot_tkn_count] = 33
      #puts "Result file named \"tokenized.txt\" is stored in current directory\n"
    end
    return exists
  end

  def main
	if ARGV[0] == nil
		print("Please enter the filename: ") 
		fname = gets.chomp
	else
		fname = ARGV[0]
    puts fname
	end
    if tokenizefile(fname)
      printtokenValues()
      filePath =  File.expand_path(File.join(File.dirname(__FILE__), "output", "tokenized.txt"))
      writeTokensToFile(filePath);
    end
  end
end

class TokenizerRunner
  def run
    Tokenizer.new.main
  end
  TokenizerRunner.new.run
end
