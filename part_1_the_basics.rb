# CHAPTER 2 -- Choose the Right Control Structure
# author = case title
#          when 'War and Peace'
#            'Tolstoy'
#          when 'Romeo and Juliet'
#          	 'Shakespeare'
#          else
#          	 "Don't know"
#          end
# Can be refactored to:

author = case title
         when 'War and Peace' then 'Tolstoy'	# Instead of 'War and Peace', could have a regex like /War And .*/
         when 'Romeo and Juliet' then 'Shakespeare'
         else "Don't know"		# Leaving this line out will default this to nil
         end

# Don't use ||= to intialize things to booleans

a = nil
a ||= "test1"    # a == test1
b = false
b ||= "test2"		 # b == test2, which is confusing, because you may have wanted it to be false

# if : unless :: while : until


# CHAPTER 3 -- Take Advantage of Ruby's Smart Collections
require 'set'

# poem_words = [ 'twinkle', 'little', 'star', 'how', 'I', 'wonder' ]
# Can be rewritten with a syntatical shortcut, given there's no spaces
poem_words = %w{ twinkle star how I wonder }

hash_literal = { "I" => 1, "don't" => 1, "like" => 1, "spam" => 963 }
old_way = { :first_name => 'Gerry', :last_name => 'Pass' }
new_way = { first_name: 'Gerry', last_name: 'Pass' }

# Can write a method that takes all the extra args
# This one will take however many args you give it and print it
def echo_all(*args)
	ars.each { |arg| puts arg }
end

def echo_at_least_two(first_arg, *middle_args, last_arg)	# Jargon for this example: splat middle_args
	puts "First arg: #{first_arg}"
	middle_args.each { |arg| puts "A middle argument: #{arg}"}
	puts "Last arg: #{last_arg}"
end
# Typically better to use splat or else your user will HAVE to input an array into the middle args

# Using .each on an array is clear. On a hash, it's only slightly more complicated.
movie = { title: '2001', genre: 'sci fi', rating: 10 }
movie.each { |name, value| puts "#{name} is #{value}"}
# title is 2001
# genre is sci fi
# rating is 10

# Useful method: find_index(word)
poem_words.find_index("star") # => 1

# Map is similar to each, but returns a modified array
poem_words.map { |word| word.size } # => [7, 4, 3, 1, 6] 

# Similar to each, can use inject. The difference being that the new arg in inject is the current result, typically sum is used
def average_word_length(words)
	total = words.inject(0) { |sum, word| word.size + sum } # Not providing zero will cause an error here
	total / words.count
end
# The 0 in this case is the original set point. If not provided, inject will use the value in the first element as the starting point
# and since in this case, that would be summing a string (rather than string.size), it returns an error

# There are many ! methods that change the original collection
# however, watch out because there are non-! methods that do the same (pop, push, delete, and shift for ex)

# Can get an object's public methods by calling: object.public_methods
# Or an object's ancestors aka superclasses: object.ancestors

# Don't always use each and map -- especially if modifying the original
# Bad example of each
array = [ 0, -10, -9, 5, 9 ]
array.each_index { |i| array.delete_at(i) if array[i] < 0 } # => [0, -9, 5, 9]   missed the second -9
# Better way to do it:
array = [ 0, -10, -9, 5, 9 ]
array.delete_if { |x| x < 0 } # => [0, 5, 9] 

# Always know the right tool for the job
# If you want an array of unique numbers in an array, this is a BAD WAY to do it
numbers = [1, 1, 2, 3, 4, 3, 2]
unique = []
numbers.each { |number| unique << number unless unique.include?(number) }
# This searches the unique array every time. Instead, can use Set after you: require 'set'
Set.new(numbers) # => #<Set: {1, 2, 3, 4}> 
unique_numbers_array = Set.new(numbers).to_a # => [1, 2, 3, 4] 


# CHAPTER 4 -- Take Advantage of Ruby's Smart Strings
# Single quote strings don't interpret
simple_string = 'Hey, that\'s a cool backslash: \\' # Only things that can be embedded are ' and \
var = "a variable"
double_quotes = "Can tab \t or do a \n new line or #{var}"

# To get out of escaping every quote, use:
str = %q{"Stop", she said, "I can't live without 's and "s."}
# The { in this case is the delimeter. Could have use %q$text_here$
# Lowercase q gives it the controls of the simple string, but caps makes it a double-quotes
str = %Q<The time in now #{Time.now}>

yet_another = %Q{another multi-line string with \
no newline}
# The \ stops a new line from being formed

# If you have a long string, instead of ending with \ can set it as a here document
heres_one = <<EOF
This is the beginning of my here document.
And this is the end.
Can add several lines if need be.
EOF

extra_spacing_word = '  hey   '
extra_spacing_word.lstrip # => "hey   " 
extra_spacing_word.rstrip # => "  hey"
extra_spacing_word.strip  # => "hey" 

"It was a dark and stormy night\n".chomp # => "It was a dark and stormy night" 
"hello\n\n\n".chomp # => "hello\n\n"   chomp only takes last \n

"hello".chop # => "hell"

'It is warm outside'.sub( 'warm', 'cold' ) # => "It is cold outside"   only does one substitution though

puts 'yes yes'.sub( 'yes', 'no' )		# => "no yes"
puts 'yes yes'.gsub( 'yes', 'no' )	# => "no no"

'It was a dark and stormy night'.split # => ["It", "was", "a", "dark", "and", "stormy", "night"] 
# Can also split by a character, like "Hey:You:There".split(":") => ["Hey", "You", "There"]

# Most string methods have a ! (bang) alternative as well

"cool that's awesome man".index("man") # => 20   character, really it starts at the 21st character

"test".each_char { |char| puts char } # => t        e        s        t
# also has .each_byte which outputs byte number and each_line

# Strings similar to JavaScript strings
first_name = "Gerry"
first_name[-1] = "Y"
puts first_name # => "GerrY" 
"abcde"[3..4] # => "de" 


# CHAPTER 5 -- Find The Right String With Regular Expressions
three_chars_x = /...x/
r_2_d_2 = /R2D2/
mr_pass_lower_or_upper = /[Mm]r\. [Pp]ass/ # [these are sets, only counts as one letter]

# Instead of typing every letter or every number, use ranges
any_single_lowercase_letter = /[a-z]/
any_number = /[0-9]/

# There are also some special cases
any_number = /\d/
any_word_count = /\w/ # letter, number, underscore

# Bars operate similar to || in Ruby
protocol = /http|https/ # Note: This will take the first one available so...
"https".match(protocol) # => "http"

# Take the time out of a string
time_as_string = "The current time is 14:08 PM".match(/\d\d:\d\d (AM|PM)/).to_s # => "14:08 PM" 
# Note: Can use parantheses instead of brackets for sets

# The asterik means 0 or more (NOT one or more) of that letter
ruby_matcher = /rub*y/ # Matches: ruy, ruby, and rubbbbby 

# Use the =~ operator to see if a regex matches a string
puts /\d\d:\d\d (AM|PM)/ =~ '10:24 PM' # => 0   this is the index where this starts
puts /(AM|PM)/ =~ '10:24 PM' # => 6

the_time = '10:24 AM'
puts "It's morning!" if /AM/ =~ the_time # => "It's morning!"

# Can also use them in gsub which finds and replaces

# \A will only match if it starts with the regex
"Once upon a time".match(/\AOnce upon a time/).to_s # => "Once upon a time"
"Hey, Once upon a time".match(/\AOnce upon a time/).to_s # => ""
# Similarly, you can do /and they all lived happily ever after\z/ and that will match end of string only

# If your string is multiline, can use ^ to replace \A and use $ to replace \z -- this will test for both
# at the end of the string and at the end of any line.

# This $ won't work if you have a \n at the end, unless you end the match /thing to match.$/m   with this m

# If using these in a conditional, remember that 0 is TRUTHY. The only FALSEY values are false and nil


# CHAPTER 6 -- Use Symbols To Stand For Something
# When using symbols, you cannot define multiple symbols with the same name like you can strings
x = "hey"
y = "hey"
x == y
x === y
# These are two different objects but
a = :symb
b = :symb
a == b # => true
a === b # => true
# The main benefit of symbols is that they don't change
# Another big benefit is that this symbol is equal to that one (i.e. :all here is the same as :all there)
# Another big benefit is that looking them up is super quick for the computer, thus making them awesome for hash key

person = {}
person[:name] = "Gerry"
person[:eyes] = "Brown"
# puts "Name: #{person['name']}, Eyes: #{person['eyes']}}"  # This will break, but not in Rails. It should be:
puts "Name: #{person[:name]}, Eyes: #{person[:eyes]}}"

# Difference between strings and symbols
# Symbols cannot be mutated. Cannot do :all.chop
# Symbols stand for something and more of a reference to something
# Strings are objects


# CHAPTER 7 -- Treat Everything Like An Object - Because It Is
# Every Ruby object is an instance of some class
# Classes are valuable because:
# 1. They store all the relevant methods
# 2. They are factories for making instances

# When calling a method, self is the instance

# Every object has a superclass up until the big daddy Object class which is the king
# Can have something inherit by saying:
# class RomanceNovel < Document
# end

# When looking for a method, start at the lowest level object, then keep going up until you find it

# When calling -3.abs you should realize that -3 is an object and abs is a method called on that object
# So when you do 1+2, it's really 1 gets the + method called and takes in 2

# Even true and false are classes of TrueClass and FalseClass, respectively
# Even nil.class returns NilClass

# Similar to how you can do object.public_methods to get an array of available methods, you can also
# run object.instance_variables to get a list of those

def public_method_here
	# stuff
end

def looks_can_be_deceiving
end

private

def private_method_here
end

private :looks_can_be_deceiving

# But note, a subclass can call its superclass' private methods!
# Since I defined (commented) RomanceNovel, if these methods above were in Document, I could call
# RomanceNovel.new(:blah).private_method_here

# If you want to call a private method, can just use instance.send(:private_method_here)
# In other words, private methods really aren't private

# If you want to know an object's class:
object = "Heyo!"
puts "The object's class is: #{object.class}" # => The object's class is: String


# CHAPTER 9 -- Write Specs!
# If using Test::Unit, need to:
# require 'test/unit'
# require 'document.rb'   # for this example

# class DocumentTest < Test::Unit::TestCase
#   def setup
#     @text = 'A bunch of words'
#     @doc = Document.new('test', 'nobody', @text)
#   end
#   def test_that_document_holds_onto_contents
#     assert_equal @text, @doc.content, 'Contents are still there'
#   end
#   def test_that_doc_can_return_words_in_array
#     assert @doc.words.include?( 'A' )
#     assert @doc.words.include?( 'bunch' )
#     assert @doc.words.include?( 'of' )
#     assert @doc.words.include?( 'words' )
#   end
#   def test_that_word_count_is_correct
#     assert_equal 4, @doc.word_count, 'Word count is correct'
#   end 
# end

# Then run the file with the tests. Will return results.

# Or using RSpec...
# require 'document'
# describe Document do
#   before :each do
#     @text = 'A bunch of words'
#     @doc = Document.new( 'test', 'nobody', @text )
#   end
#   it 'should hold on to the contents' do
#     @doc.content.should == @text
#   end
#   it 'should know which words it has' do
#     @doc.words.should include( 'A' )
#     @doc.words.should include( 'bunch' )
#     @doc.words.should include( 'of' )
#     @doc.words.should include( 'words' )
#   end
#   it 'should know how many words it contains' do
#     @doc.word_count.should == 4
#   end 
# end

# STUBS
# Can create a stub object, which would be an stubbed instance of another class
# stub_printer = stub :available? => true, :render => nil
# Can also stub a single method
# apparently_long_string = 'actually short'
# apparently_long_string.stub!( :length ).and_return( 1000000 )
# Note: Only works in tests