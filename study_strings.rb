# PUBLIC CLASS METHODS
String.new("hey") # => "hey"


# PUBLIC INSTANCE METHODS
# Check Kernel::sprintf for more formats
"%05d" % 123                              #=> "00123"
"%-5s: %08x" % [ "ID", self.object_id ]   #=> "ID   : 200e14d6"
"foo = %{foo}" % { :foo => 'bar' }        #=> "foo = bar"

"Ho! " * 3 # => "Ho! Ho! Ho! "

"hey " + "you" # => "hey you"
"hey " << "you" # => "hey you"
"you".prepend("hey ") # => "hey you"

"hey" <=> "you" # => -1
"abcde" <=> "abc" # => 1
"abc" <=> "abc"	# => 0
"abc" <=> "ABC" # => 1
# Case insensitive version of <=>
"abc".casecmp("ABC") # => 0

"cat o' 9 tails" =~ /\d/   #=> 7

a = "hello there"
a[0] # => "h"
a[2, 3] # => "llo"
a[2..3] # => "ll"
a[/[aeiou]/] # => "e"
a["lo"] # => "lo"
a["bye"] # => nil
a.chr # => "h"

a.bytes # => [104, 101, 108, 108, 111, 32, 116, 104, 101, 114, 101]     same as a.each_byte.to_a
a.bytesize # => 11
a.each_byte { |b| puts b, ' ' } # 104     101     108 ...
a.chars # => ["h", "e", "l", "l", "o", " ", "t", "h", "e", "r", "e"]    same as a.each_char.to_a
a.each_char { |c| puts c, ' ' } # h     e     l ...

a.capitalize	# => "Hello there"
# Has ! equivalent
"Hello".swapcase # => "hELLO" 
# Has ! equivalent
"Hello".upcase # => "HELLO"
# Has ! equivalent
"Hello".downcase # => "hello"
# Has ! equivalent

"hello".center(4)         # => "hello"
"hello".center(20)        # => "       hello        "
"hello".center(20, '123') # => "1231231hello12312312"
"hello".ljust(20, '1234') # => "hello123412341234123"
"hello".rjust(20)					# => "               hello"

"  hello  ".lstrip   # => "hello  "
"  hello  ".rstrip   # => "  hello"
"  hello  ".strip   # => "hello"


"hello\n".chomp # => "hello"    removes carriage returns
# Has ! equivalent

a.clear # ! => ""
"hello".delete "lo"            #=> "he"
# Has ! equivalent

a = "hello world"
a.count "lo"            # => 5
a.count "lo", "o"       # => 2
a.count "hello", "^l"   # => 4
a.include?("lo")				# => true
a.index("lo")						# => 3
a.rindex("o")						# => 7

" ".empty? # => false
"".empty?  # => true

a.start_with?("hell") # => true
a.end_with?("ld") # => true

"hello".gsub(/[aeiou]/, '*')                  #=> "h*ll*"
# Has ! equivalent
# Can also do just .sub which only change the first occurrence
# There is also a similar .tr which is like gsub but slightly faster.

"0x0a".hex # => 10
"123".oct  #=> 83
"123.45e1".to_f        #=> 1234.5
"45.67 degrees".to_f   #=> 45.67
"12345".to_i             #=> 12345
"99 red balloons".to_i   #=> 99
'  2  '.to_r       #=> (2/1)
'300/2'.to_r       #=> (150/1)
'-9.2'.to_r        #=> (-46/5)

s = "hello"         #=> "hello"
s.replace "world"   #=> "world"
"abcd".insert(3, 'X')    #=> "abcXd"
str = "hello"
str[3] = "\b"
str.inspect       #=> "\"hel\\bo\""

"cat".to_sym	# => :cat

a.length # => 11

'hello'.match('(.)\1')[0]   # => "ll"

"abcd".succ        #=> "abce"
"THX1138".succ     #=> "THX1139"
# Has ! equivalent

# Returns an array of the part before the match, the match, and the part after it
"hello".partition("l")         #=> ["he", "l", "lo"]
# Also has rpartition which looks from end of string to front

"hello".reverse # => "olleh"
# Has ! equivalent

a = "cruel world"
a.scan(/\w+/)        #=> ["cruel", "world"]
a.scan(/.../)        #=> ["cru", "el ", "wor"]
a.scan(/\w+/) {|w| print "<<#{w}>> " }
print "\n" # => <<cruel>> <<world>>
a.scan(/(.)(.)/) {|x,y| print y, x }
print "\n" # => rceu lowlr


" now's  the time".split        #=> ["now's", "the", "time"]
" now's  the time".split(' ')   #=> ["now's", "the", "time"]
" now's  the time".split(/ /)   #=> ["", "now's", "", "the", "time"]
"hello".split(//)               #=> ["h", "e", "l", "l", "o"]
"hello".split(//, 3)            #=> ["h", "e", "llo"]

"yellow moon".squeeze                  #=> "yelow mon"
"  now   is  the".squeeze(" ")         #=> " now is the"
"putters shoot balls".squeeze("m-z")   #=> "puters shot balls"
# Has ! equivalent

