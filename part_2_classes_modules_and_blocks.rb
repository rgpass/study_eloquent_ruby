# CHAPTER 10 -- Construct Your Classes From Short, Focused Methods
# Break up your methods so they have three characteristics:
# 1. Each method should do a single thing. It should focus on solving a single aspect of the problem. 
#    This promotes readability and ease of testing.
# 2. Each method needs to operate at a single conceptual level. Do not combine business logic with a currency converter.
# 3. Methods should be named well, especially when you have lots of little ones. When this is done, it's possible for
#    the code to guide you through it.
# Also: Methods should always have one return. They need to convert to a single end point.
# Also: It should be short and coherent. It should be compact while still doing something.


# CHAPTER 11 -- Define Operators Respectfully
# Ruby has the ability to overload operators, aka change the methods behind
# +, -, *, /
# Each of these symbols is actually a method, so
2+3
# is the same as
2.+(3)

# If you ever have/want to do this, refer to this chapter


# CHAPTER 12 -- Create Classes That Understand Equality
# The x.equal?(y) operator and the == operator are the same
# They only show true if both objects are the SAME object
# If you make two objects that are identifical, both equal? and == will return false

# As discussed in the chapter 11, it's possible to overwrite these. For example:
class DocumentIdentifier
  attr_reader :folder, :name

  def initialize( folder, name )
    @folder = folder
    @name = name
  end

  def ==(other)
  	return true if other.equal?(self)
    return false unless other.instance_of?(self.class)
    folder == other.folder && name == other.name
  end 
end
# The problem here is that typically the roles cannot be reversed when overwriting
# default operators.
# People expect when a == b that b == a, which in the above case wouldn't be true.

# If you ever have/want to do this, refer to this chapter


# CHAPTER 13 -- Get The Behavior You Need With Singleton And Class Methods
# Singleton method: A method that is defined for exactly one object instance.
# This term of singleton has nothing to do with the Singleton Pattern of design patterns.
# This is confusing, but should be known.

# Singleton methods can be used on all class instances except Numeric and Symbol classes.

# This is done in Ruby because between the parent class and the class created, there is a
# Singleton class, allowing for this to happen.
# Parent class > Singleton > Instance

# Other terms for Singleton class: metaclass and eigenclass.

# Singleton classes aren't just for stubs and mocks. Class methods are singleton methods.
# Think about it like this: the class method is a singleton method from the perspective
# of the superclass -- it has a method that's there ONLY for this specific class.

class Document
	class << self
		# Class methods can be defined here.
		# Line 18 brings in the singleton version
	end
end

# With any class or instance, try running class.singleton_methods or @instance.singleton_methods

# Note: self is always the thing before the period on the method that you called


# CHAPTER 14 -- Use Class Instance Variables
# Don't use class variables (@@variable_name) because if two subclasses have the same
# class variable name, they will overwrite each other, depending on which one gets
# loaded second. If you must use them, define them early in the code.

# Instead, set an instance variable and have the class' initialize method
# call that instance variable.

class Document
  @default_font = :times
  def self.default_font=(font)
    @default_font = font
	end
  def self.default_font
    @default_font
	end
	# Rest of the class omitted...

	def initialize(title, author)
	  @title = title
	  @author = author
	  @font = Document.default_font
	end
end


# CHAPTER 15 -- Use Modules As Name spaces
# Modules vs Classes
# Can't instantiate a module. A class is a factory + a container that holds its
# methods and variables. A module is just the container.
# Modules can have methods, constants, classes, and other modules

# Example module with multiple classes
module Rendering
  class Font
    attr_accessor :name, :weight, :size
    def initialize( name, weight=:normal, size=10 )
      @name = name
      @weight = weight
      @size = size
		end
    # Rest of the class omitted...
  end

  class PaperSize
    attr_accessor :name, :width, :height
    def initialize( name='US Let', width=8.5, height=11.0 )
      @name = name
      @width = width
      @height = height
		end
    # Rest of the class omitted...
  end

  DEFAULT_FONT = Font.new( 'default' )
  DEFAULT_PAPER_SIZE = PaperSize.new
end

# Can call the font class above with
Rendering::Font
# This way your Font class will not collide with another Font class

# If you get tired of writing Rendering:: can just put
include Rendering
puts "The default paper height is #{DEFAULT_PAPER_SIZE.height}"

# If you nested Rendering inside a WordProcessor module, would either have
# to call classes like WordProcessor::Rendering::Font
# or would have to put include WordProcessor::Rendering

# Modules are great places to put random methods. For ex:
module WordProcessor
  def self.points_to_inches( points )
    points / 72.0
	end
  def self.inches_to_points( inches )
    inches * 72.0
	end
  # Rest of the module omitted
end
# Putting them as a module-level methods (aka having self) enables you to write
an_inch_full_of_points = WordProcessor.inches_to_points( 1.0 )
# Could also get there with WordProcessor::inches_to_points, but the above is easier

# The good rule of thumb for when to create a module is when you find yourself
# making classes that start with the same few words. For example, if you had a 
# RenderingFont class and a RenderingPaperSize, may just be better to have both
# of those in one module.

# However, do not make modules more than 2 or 3 levels deep or else you'll
# have to write out a ridiculously long set of words to get to a class

# Can set variables equal to different modules, so then you can treat them like
# objects.


# CHAPTER 16 -- Use Modules As Mixins
# The way to reuse code amongst two classes that are different is to use a Mixin Module.

# Create a module that has the shared code
module WritingQuality
  CLICHES = [ /play fast and loose/,
              /make no mistake/,
              /does the trick/,
              /off and running/,
              /my way or the highway/ ]
  def number_of_cliches
    CLICHES.inject(0) do |count, phrase|
      count += 1 if phrase =~ content
			count 
		end
	end 
end
# Note: Methods are instance methods, not module level methods.

class Document
  include WritingQuality
  # Lots of stuff omitted...
end

class ElectronicBook < ElectronicText
  include WritingQuality
  # Lots of stuff omitted...
end
# And now you're done. You can call these methods:
text = "my way or the highway does the trick"
my_tome = Document.new('Hackneyed', 'Russ', text)
puts my_tome.number_of_cliches
# or
my_ebook = ElectronicBook.new( 'EHackneyed', 'Russ', text)
puts my_ebook.number_of_cliches

# In this example, WritingQuality is a Mixin Module.

# In a sense, this is polymorphism applied to Ruby, which typically only
# allows one super.

# The example above uses the module on instances of Document.
# If you want to use these methods as a Document class method:
module Finders
  def find_by_name( name )
    # Find a document by name...
  end
  def find_by_id( doc_id )
    # Find a document by id
	end 
end

class Document
  # Most of the class omitted...
	class << self
    include Finders
	end 
end
# Since this is so common, Ruby provides another option to do this:
class Document
  extend Finders
  # Most of the class omitted...
end
# Now you have these available:
Document.find_by_name('blah')
Document.find_by_id(5)

# Module Mixins interject themselves between the class and its super
# when the code is processed. However, you can't run object.class.superclass
# because that will return its normal superclass.
# To find out if it's a mixin, you can run object.kind_of?(mixin_name) => true
# Can also try object.ancestors

# In the scenario that you want all the code in a Module Mixin except for one thing
# you can override it in your class. Since Module Mixins act as a super, defining it
# again in the sub will override it.

# If you have two modules mixed in and they share a method name, the
# most recent one called in the code will win.

# Rails' helper methods are Mixin Modules.


# CHAPTER 17 -- Use Blocks To Iterate
def do_something
  yield if block_given?
end
# If a block is given to the code, it will yield the function.

def do_something_with_an_arg
  yield("Hello World") if block_given?
end

do_something_with_an_arg do |message|
  puts "The message is #{message}"
end
# Running this would return: "The message is Hello World"

def print_the_value_returned_by_the_block
  if block_given?
		value = yield
    puts "The block returned #{value}"
  end
end
print_the_value_returned_by_the_block { 3.14159 / 4.0 } # => "The block returned 0.7853975"
# This if block_given? is why methods in Ruby will act differently depending
# on if a block is given or something else.

# A normal iterator calls its block once for each element in the collection.

class Document
  # Stuff omitted...
  def each_word
    word_array = words
    index = 0
    while index < words.size
      yield( word_array[index] )
			index += 1 
		end
	end 
end
# Can now call...
d = Document.new( 'Truth', 'Gump', 'Life is like a box of ...' )
d.each_word {|word| puts word} # => Life    is      like      a      box    of    ....

# A smarter way to do the above would be to use the each method that's already there.
def each_word
	words.each { |word| yield(word) }
end

# If you want to have two elements yielded, can do:
class Document
  # Most of the class omitted...
  def each_word_pair
    word_array = words
    index = 0
    while index < (word_array.size-1)
      yield word_array[index], word_array[index+1]
			index += 1 
		end
	end 
end
# Calling it...
doc = Document.new('Donuts', '?', 'I love donuts mmmm donuts' )
doc.each_word_pair{ |first, second| puts "#{first} #{second}" } # => I love     love donuts     donuts mmmm     mmmm donuts

# If your class is enumerable, make sure to have:
include Enumerable
# which has a plethora of enumerable methods

# When building your own iterator, make sure to use begin   rescue/ensure
# and also, put breaks in there to escape when necessary

# Some cool blocks
# Want to see all the DNS IPs?
require 'resolv'
Resolv.each_address( "www.google.com" ) {|x| puts x} 
# => 74.125.131.106     74.125.131.105     74.125.131.147     74.125.131.104     74.125.131.103     74.125.131.99

require 'mathn'
# Warning: According to Euclid, this never stops...
Prime.each {|x| puts "The next prime is #{x}" }


# CHAPTER 18 -- Execute Around With A Block
# Blocks can be used for more than just iterating.
class SomeApplication
  def do_something
		with_logging('load') { @doc = Document.load( 'resume.txt' ) }
    # Do something with the document...
		with_logging('save') { @doc.save }
	end
  	# Rest of the class omitted...
  def with_logging(description)
    begin
      @logger.debug( "Starting #{description}" )
      yield
      @logger.debug( "Completed #{description}" )
    rescue
      @logger.error( "#{description} failed!!")
      raise
		end 
	end
end
# In this example, you can log different things while using a block
# and its yield to do its normal work.

# "Bury the details in a method that takes a block" is called an Execute Around.

# Execute Arounds should only take variables that a normal method would need to operate.
# In other words, don't load in a @instance_variable into the method.

def with_database_connection( connection_info )
  connection = Database.new( connection_info )
  begin
		yield( connection ) 
	ensure
    connection.close
  end
end
# This method creates a new database connection, that passes that connection into the block.
# After it is run, it closes that connection.

# If you want the block method to return something, such as map, need do set it to something like:
def with_logging(description)
  begin
		@logger.debug( "Starting #{description}" ) 
		return_value = yield
		@logger.debug( "Completed #{description}" ) 
		return_value
  rescue
    @logger.error( "#{description} failed!!")
    raise
	end 
end

# Execte Arounds must handle all exceptions really well.
# Their naming should be much clearer. Think of it as naming a new feature.

# Use Execute Around when you frequently have code that needs to come before or after
# another set of code, or both. This way you can define a method that takes a block,
# runs the necessary before code, then runs the block arguments given (like @doc = Document.new)
# then runs the after code.


# CHAPTER 19 -- Save Blocks To Execute Later
# Adding a & in front of an arg makes it a block, which can be called with the call method
def run_that_block( &that_block )
  puts "About to run the block"
  that_block.call # if that_block  # this checks to see if a block was passed
  puts "Done running the block"
end

# Can delay execution of something using blocks.
# Reread this chapter if/when that's applicable.

# This chapter discusses Lambda vs Proc.new