# ABOUT THE BOOK:
# Eloquent Ruby is an awesome book for stepping up to the next level of Ruby. It's considered one of the
# best books ever written about Ruby.


# ACTION ITEMS:
# [X] Combine chapters into parts
# [*] When done the book, review the notes and read the Wrapping Up from each section
# 	[X] Part 1
# 	[X] Part 2
# 	[X] Part 3
# 	[*] Part 4
# [X] Review and practice all Array methods
# [X] Review and practice all Hash methods
# [X] Review and practice all String methods -- not an option!
# [X] Research the eval method -- it's very powerful, so need to understand
# [X] Research more about Protected methods (protected vs private)
# [X] Understand the differences between: equal?, ==, ===, and eql?
# [X] Look up other Execute Arounds to see other uses for them
# [19] Reread the chapter when you want to execute code at a later time via blocks
# [X] Research lambda vs proc_new
# [*] Go back and read Chapter 20 on once you've read through the metaprogramming book. Continue notes.
# [*] Do some Euler challenges. Make it highly organized with diff files and classes. Reference: http://apidock.com/ruby/Prime
# [*] Go through the tests blog (http://rubyspec.org/) when working on next project
# [21] Mess around with Soundex in the text gem. See notes for an example.
# [25] Since class files are executable, make your previous Rigor and RentPath code a class and re-organize. May need to inherit
# 		 or require certain modules/classes.
# [26] Re-read the chapter to better understand associations


# GENERAL NOTES:
# [5] Never shy away from a chance to learn more about regex. It is a powerful tool.
# [12] Whenever using an equals operator on hashes or classes, always test that it works the way you want it to.


# NOTES FROM ACTION ITEMS:
# Protected: Can be called on any instance or subclass of the class where the method was defined
# Private: Can only be called by the calling object. Cannot access another instance's private methods.
# In Ruby, these are just recommendations though since you can access a private method with .send

# == and eql are the same, except for Numeric
1.eql?(1.0) # => false
# equal? is a pointer comparison and should never overwritten. This is true only if it's the same object instance.

# Good example of Execute Around: http://sleeplessgeek.blogspot.com/2011/06/using-execute-around-pattern-in-ruby.html

# Reference: http://stackoverflow.com/questions/1740046/whats-the-difference-between-a-proc-and-a-lambda-in-ruby
# Lambdas will alert if wrong number of arguments. Proc will not.
# Can use return in Lambda.
