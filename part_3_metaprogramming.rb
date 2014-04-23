# CHAPTER 20 -- Use Hooks To Keep Your Program Informed
# A hook is code that gets called to tell you that something is about to happen
# or has just happened.
class SimpleBaseClass
  def self.inherited( new_subclass )
    puts "Hey #{new_subclass} is now a subclass of #{self}!"
  end
end

class ChildClassOne < SimpleBaseClass
end
# Result: "Hey ChildClassOne is now a subclass of SimpleBaseClass!"
# This utilizes the inherited hook. An example of where this is useful is
# if each Document could have a different format. Instead of loading all the
# format reading code into Document, you can call it based off inherited

# The module version of inherited is included
module WritingQuality
  def self.included(klass)
    puts "Hey, I've been included in #{klass}"
  end
  def number_of_cliches
    # Body of method omitted...
	end 
end

# If you have a module that has useful instance methods and useful
# class methods, you can either make two separate modules and include them
# like so:
module UsefulInstanceMethods
  def an_instance_method
  end
end

module UsefulClassMethods
  def a_class_method
  end
end

class Host
  include UsefulInstanceMethods
  extend UsefulClassMethods
end
# Or a much better way, would be to use the included hook
module UsefulMethods
  module ClassMethods
    def a_class_method
		end 
	end
  def self.included( host_class )
    host_class.extend( ClassMethods )
	end
  def an_instance_method
  end
  # Rest of the module deleted...
end

class Host
  include UsefulMethods
end
# So now it has all the instance methods that come with include, but also
# the ClassMethods module is extended when the included hook is called


# Another method is the at_exit block, which happens when the interpreter is closing.
at_exit do
  puts "Have a nice day."
end
at_exit do
  puts "Goodbye"
end
# Upon exit: Goodbye     Have a nice day.
# at_exit is a LIFO operator

# An issue with hooks is knowing how and when they'll be called. If you make a sub
# on a sub that has inherited, the sub sub will call it as well. Another example is
# if there's a crash, at_exit may not be called.

# Note: $! is a global variable that Ruby sets to the last exception raised.


# CHAPTER 21 -- Use method_missing For Flexible Error Handling
# A couple of flexible error handling methods are:
# method_missing and const_missing

# All the way up in the Object class (actually in Kernel), there's a method_missing
# method that gets called if an object doesn't have a method and it cannot be found
# anywhere up the super chain.

# By overriding this message, you can customize your method missing on a per class basis.
class RepeatBackToMe
  def method_missing( method_name, *args )
    puts "Hey, you just called the #{method_name} method"
    puts "With these arguments: #{args.join(' ')}"
    puts "But there ain't no such method"
	end 
end

# Can use this to return an error message.
class Document
  # Most of the class omitted...
  def method_missing( method_name, *args )
    msg =  %Q{
      You tried to call the method #{method_name}
       on an instance of Document. There is no such method.
		}
		raise msg 
	end
end

# Or return the standard method but track the errors.
class Document
  # Most of the class omitted...
  def method_missing( method_name, *args )
    File.open( 'document.error', 'a' ) do |f|
      f.puts( "Bad method called: #{method_name}" )
      f.puts( "with #{args.size} arguments" )
    end
		super 
	end
end

# Or if you're nice, you can help people toward potential options.
require 'text'  # From the text gem
class Document
  include Text
	# Most of the class omitted...
  def method_missing( missing, *args )
    candidates = methods_that_sound_like( missing.to_s )
    message = "You called an undefined method: #{missing}."
    unless candidates.empty?
      message += "\nDid you mean #{candidates.join(' or ')}?"
		end
    raise raise NoMethodError.new( message )
  end

  def methods_that_sound_like( name )
    missing_soundex = Soundex.soundex( name.to_s )
    public_methods.sort.find_all do |existing|
      existing_soundex = Soundex.soundex( existing.to_s )
      missing_soundex == existing_soundex
    end
	end
end
# Soundex operates on similar sounding words, so trying to run document.contnt
# would return:
# You called an undefined method: contnt.
# Did you mean content or content=?

# const_missing is similar to method_missing, but has only one argument (the constant)
# and it has to be a class method (since constants are on the class)
class Document
  # Most of the class omitted...
	def self.const_missing( const_name ) 
		msg = %Q{
      You tried to reference the constant #{const_name}
      There is no such constant in the Document class.
   	}
		raise msg 
	end
end

# Typically only want to use method_missing and const_missing when truly necessary.
# Also note that if your custom method_missing has a missing method, it will cause an
# infinite loop.


# CHAPTER 22 -- Use method_missing For Delegation
# Instead of making a sub have similar methods to its parent, can always do:
class SuperSecretDocument
  # Lots of code omitted...
	DELEGATED_METHODS = [ :content, :words ]
	def method_missing(name, *args) 
		check_for_expiration
		if DELEGATED_METHODS.include?( name )
      @original_document.send(name, *args)
    else
			super
		end
	end 
end
# This example assumes @original_document is set in initialize
# Also it checks from an approved list of methods to call


# CHAPTER 23 -- Use method_missing To Build Flexible APIs
# You can use method_missing to generate new methods.
class FormLetter < Document
  def replace_word( old_word, new_word )
    @content.gsub!( old_word, "#{new_word}" )
  end
  def method_missing( name, *args )
    string_name = name.to_s
    return super unless string_name =~ /^replace_\w+/
    old_word = extract_old_word(string_name)
    replace_word( old_word, args.first )
	end
  def extract_old_word( name )
    name_parts = name.split('_')
    name_parts[1].upcase
	end 
end
# This is saying that if replace_someword does not exist,
# try creating a method that replaces someword.
# If you ran the above code and wrote: replace_gender('dude')
# it would pull out the word gender, then replace_word('GENDER', 'dude')

# This variation on method_missing is sometimes called Magic Methods.

# The problem with this is that you have to be aware of name collisions.
# For ex, you could not do replace_word('hey') because you'd only have 1 of 2 args.
# Also, respond_to? works only on defined methods, not Magic Methods.
# So respond_to?(:replace_gender) would fail. This can be fixed with:
def respond_to?(name)
  string_name = name.to_s
  return true if string_name =~ /^replace_\w+/
  super
end

# ActiveRecord uses Magic Methods -- anytime you do something like
# Users.find_by_email('rgpass@gmail.com') -- it does something similar
# to the above example.


# CHAPTER 24 -- Update Existing Classes With Monkey Patching
# When you add a method to a class, it is accessible to any instance already
# created. So you can go: initalize, add method, call that method.

# It's also possible to redefine methods. In this case, it's last def wins.
# Redefining a method (for ex if you're working on code that isn't yours
# but is still broken) 'on the fly' is called Monkey Patching.

class String
  def +( other )
    if other.kind_of? Document
      new_content = self + other.content
      return Document.new(other.title, other.author, new_content)
    end
    result = self.dup
    result << other.to_str
    result
	end 
end
# This is the fix to issue from Chp11 where you could do Document + string
# but not string + Document. Notice how you have to open up the String
# class first before making any changes.

# Alias Method is when you give a new name to a method.
class Document
  # Stuff omitted...
  def word_count
    words.size
	end
  alias_method :number_of_words, :word_count
  alias_method :size_in_words,   :word_count
  # Stuff omitted...
end

# Since Monkey Patching requires that you retype all the old code
# (which isn't very DRY), you can combine this with Alias Method
# to keep it DRY.
# So if you start with...
class String
  def +( other )
    if other.kind_of? Document
      new_content = self + other.content
      return Document.new(other.title, other.author, new_content)
    end
    result = self.dup
    result << other.to_str
    result
	end 
end
# Can turn it into...
class String
  alias_method :old_addition, :+
  def +( other )
    if other.kind_of? Document
      new_content = self + other.content
      return Document.new(other.title, other.author, new_content)
    end
    old_addition(other)
	end 
end

# Aliasing allows for any modifications that you could have done the first time.
class Document
  private :word_count
end
class Document
  public :word_count
end
class Document
  remove_method :word_count
end


# CHAPTER 25 -- Create Self Modifying Classes
# Classes are executable.
class Widget
	puts instance_methods(false)

	def test
	end

	puts instance_methods(false)
end
# If you load this class, it will return:
# []
# [:test]

# Since you can define methods on the fly, can have conditionals
# that use them as well.
class Document
  # Lots of code omitted...
  def save( path )
    File.open( path, 'w' ) do |f|
      f.puts( encrypt( @title ))
      f.puts( encrypt( @author ) )
      f.puts( encrypt( @content ))
		end 
	end

  if ENCRYPTION_ENABLED
    def encrypt( string )
      string.tr( 'a-zA-Z', 'm-za-lM-ZA-L')
    end
  else
    def encrypt( string )
			string 
		end
	end 
end

# Can have conditionals based on Ruby version
class Document
  # Lots of stuff omitted...
  if RUBY_VERSION >= '1.9'
    def char_at( index )
      @content[ index ]
    end
  else
    def char_at( index )
      @content[ index ].chr
    end
	end 
end


# CHAPTER 26 -- Create Classes That Modify Their Subclasses
# If you wanted to define a method whose name is a variable, you would
# get to this point and get stuck:
class StructuredDocument
  def self.paragraph_type( paragraph_name, options )
    def <<the new method>>
        # Add a new paragraph
    end
	end
end
# However, by using class_eval, you can write the code and then call
# class_eval to convert your data into code.
class StructuredDocument
  def self.paragraph_type( paragraph_name, options )
    name = options[:font_name] || :arial
    size = options[:font_size] || 12
    emphasis = options[:font_emphasis] || :normal
    code = %Q{
      def #{paragraph_name}(text)
      	p = Paragraph.new(:#{name}, #{size}, :#{emphasis}, text)
				self << p 
			end
		}
    class_eval( code )
  end
end
# By doing this, you can create code that builds itself at run-time.

# This strategy of define-on-the-fly is never as good as a normal API alternative.
# In this case, we can use define_method
class StructuredDocument
  def self.paragraph_type( paragraph_name, options )
    name = options[:font_name] || :arial
    size = options[:font_size] || 12
    emphasis = options[:font_emphasis] || :none
    define_method(paragraph_name) do |text|
      paragraph = Paragraph.new( name, size, emphasis, text )
      self << paragraph
		end 
	end
end

# This code happens all the time. For example:
class Printer
  attr_accessor :name
end
# is essentially:
class Printer
  def name
		@name
	end
  def name=(value)
    @name = value
	end
end
# So what's is attr_accessor doing? Here's attr_reader:
class Object
  def self.simple_attr_reader(name)
    code = "def #{name}; @#{name}; end"
    class_eval( code )
  end
end
# And attr_writer:
class Object
  def self.simple_attr_writer(name)
    method_name = "#{name}="
    define_method( method_name ) do |value|
      variable_name = "@#{name}"
      instance_variable_set( variable_name, value )
    end
	end
end

# Also, every Rails association does this subclass-modifying practice!