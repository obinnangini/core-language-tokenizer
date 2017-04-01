=begin
NOTES ON PROGRAM
Written by Obinna U Ngini. First ruby program try(not counting hello world script)
Program splits file line by line, and then splits each line by whitespace. The function tokenize is then called
on each word to split it into tokens according to the Core syntax
Each token is then evaluated, and the corresponding value is printed to the console
=end


#require 'io/console'
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
def whitespace?(lookAhead)
	lookAhead =~ /\s+/
end
def tokenize(input)
	Array tokens = Array.new
	token_count = 0
	tkn = ""
	#x = 0
	state = 1 #letter is starting postition
	
	for x in 0..input.length-1
		added_symbol = false
		if state == 0 #error
			#Keep collecting characters until a 
			if not $symbols.include?(input[x])
				tkn<<input[x]
				#print "tkn #{tkn}"
				state = 0
			else
				#tokens[token_count] = tkn
				#token_count = token_count + 1
				state = 3
			end
		end
		if state == 1#collecting letter
			#Keep collecting letters while in this states
			if letter?(input[x])
				tkn<<input[x]
				state = 1
			#Change to digit collection state if a digit is seen
			elsif numeric?(input[x])
				state = 2
			#Change to symbol collection state
			elsif $symbols.include?(input[x])
				#puts"1st add"
				#If there is a non empty token so , add to array of tokens
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
			#Go tot error state if letter comes after digit
			if letter?(input[x])
				tkn<<input[x]
				state = 0
			elsif numeric?(input[x])
				state = 2
				tkn<<input[x]
			elsif $symbols.include?(input[x])
				#puts"2nd add"
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
				#puts"3rd add"
				tokens[token_count] = tkn
				token_count = token_count + 1
				tkn = input[x]
				state = 1
			elsif numeric?(input[x])
				#puts"4th add"
				tokens[token_count] = tkn
				token_count = token_count + 1
				tkn = input[x]
				state = 2
			elsif $symbols.include?(input[x])
				#puts "tkn length is #{tkn.length}"
				if input[x] == '='
					if tkn.length > 0 and added_symbol == false
						if tkn[0] == '>' or tkn[0] == '<' or tkn[0] == '!' or tkn[0] == '='
							tkn<<input[x]
							state = 3
						else
							state = 0
						end
					end
				elsif input[x] == '&'
					if tkn[tkn.length - 2] ==  '&'
						tkn<<input[x]
					else
						state = 0
					end
				elsif input[x] =='|'
					if tkn[tkn.length -2] ==  '|'
						tkn << input[x]
					else
						state = 0
					end
				end
			end
		end
		#puts"Input #{input[x]} state #{state} tkn #{tkn}\n"
	end

	#add the last stuff to the  array if not state == 0
	#if not state == 0
		#puts"Outside add"
		tokens[token_count] = tkn
	#end
	#simple token test
	#tokens.each do |test|
	#	puts test
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
	elsif identifier?(input)
		x = 32
	else
	# Else token is an 
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
	#puts "#{flag}"
	return flag
end

def identifier?(input)
	#Make sure identifier is all caps letters and numbers and numbers only come at the end
	flag = true
	state = 1
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
				break
			elsif numeric?(input[x])
				state = 2
			end
		end
	end
	return flag
end

def main
	if ARGV[0] == nil
		print("Please enter the filename: ") 
		fname = gets.chomp
	else
		fname = ARGV[0]
	end
	if File.file?(fname)
		#Dir.chdir "C:\Users\Obinna\Documents"
		#output = File.open("C:\\Users\\Obinna\\Documents\\tokenized.txt", 'w')
		#output = File.open("tokenized.txt", 'w')
		File.open(fname, 'r').each do |line|
			Array temp = line.split()
			temp.each do |word|
				Array tokens = 	tokenize(word)
				tokens.each do |token|
					
					value = evaltoken(token)
					#puts(token)
					if value == 35
						puts "Error token found. Program will now exit."
						Process.exit!()
					end
					puts(value)
					#puts "token:#{token} value:#{value}"
				end
			end
		end
		#write 33 to file at the end
		#output.puts("33");
		#output.close()
		puts("33")
		#puts "Result file named \"tokenized.txt\" is stored in current directory\n"
	end
end
main
