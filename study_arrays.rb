# CREATING ARRAYS
array = [1, "two", 3.0]
blank_array = Array.new()
blank_array_2 = []
three_nils = Array.new(3)
three_trues = Array.new(3, true) # => [true, true, true]
four_hashes = Array.new(4) { Hash.new } # => [{}, {}, {}, {}]
diff_array_creator = Array({a: 1, b: 2}) # => [[:a, 1], [:b, 2]]


# ACCESSING ELEMENTS
numbers = [1, 2, 3, 4, 5, 6]
numbers[2] # => 3
numbers[-3] # => 4
numbers[100] # => nil
numbers[2, 3] # => [3, 4, 5]   starts at index 2, returns 3 numbers
numbers[4, 3] # => [5, 6]
numbers[1..4] # => [2, 3, 4, 5]
numbers.at(2) # => 3
numbers.values_at(1, 3, 5) # => [2, 4, 6]

numbers.fetch(4)
numbers.fetch(100) # => Error
numbers.fetch(100, "Out of range!") # => "Out of range!"    the second option gives a default value

numbers.first # => 1
numbers.last # => 6
numbers.take(2) # => [1, 2]   takes the first n of an array
numbers.drop(1) # => [2, 3, 4, 5, 6]     opposite of take, drops the first n


# OBTAINING INFORMATION ABOUT AN ARRAY
snowboard_companies = %w{ Burton Ride K2 Arbor Forum }
snowboard_companies.length # => 5
snowboard_companies.size # => 5
snowboard_companies.count # => 5    other elements don't have count, but they do have length and size
# A benefit of using count is that you can run a couple of different options on it
numbers = [1, 2, 4, 2, 2]
numbers.count # => 5
numbers.count(2) # => 3
numbers.count { |x| x%2 == 0 } # => 4

snowboard_companies.empty? # => false
blank_array.empty? # => true
[""].empty? # => false

snowboard_companies.include?('Skiing') # => false


# ADDING ITEMS TO ARRAYS
numbers.push(7) # ! => [1, 2, 3, 4, 5, 6, 7]
numbers << 8 # ! => [1, 2, 3, 4, 5, 6, 7, 8]
numbers.unshift(0) # ! => [0, 1, 2, 3, 4, 5, 6, 7, 8]
numbers.unshift(-2, -1) # ! => [-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8]
numbers.insert(3, 'this', 'doesn\'t', 'belong') # ! => [-2, -1, 0, "this", "doesn't", "belong", 1, 2, 3, 4, 5, 6, 7, 8]
numbers.pop # ! => [-2, -1, 0, "this", "doesn't", "belong", 1, 2, 3, 4, 5, 6, 7]     but returns 8
numbers.pop(2) # ! => [-2, -1, 0, "this", "doesn't", "belong", 1, 2, 3, 4, 5]     but returns [6, 7]
numbers.shift # ! => [-1, 0, "this", "doesn't", "belong", 1, 2, 3, 4, 5]     but returns -2
numbers.shift(2) # ! => ["this", "doesn't", "belong", 1, 2, 3, 4, 5]     but returns [-1, 0]


# REMOVING ITEMS FROM AN ARRAY
numbers.pop # ! => 8        	numbers => [-2, -1, 0, "this", "doesn't", "belong", 1, 2, 3, 4, 5, 6, 7]
numbers.pop(2) # ! => [6, 7]	numbers => [-2, -1, 0, "this", "doesn't", "belong", 1, 2, 3, 4, 5]
numbers.shift # ! => -2       numbers => [-1, 0, "this", "doesn't", "belong", 1, 2, 3, 4, 5]
numbers.delete_at(1) # ! => 0 numbers => [-1, "this", "doesn't", "belong", 1, 2, 3, 4, 5]
new_numbers = [1, 2, 2, 3]
new_numbers.delete(2) # ! => 2  new_numbers => [1, 3]

arr = ['foo', 0, nil, 'bar', 7, 'baz', nil]
arr.compact # => ["foo", 0, "bar", 7, "baz"]   also has ! version
arr = [2, 5, 6, 556, 6, 6, 8, 9, 0, 123, 556]
arr.uniq # => [2, 5, 6, 556, 8, 9, 0, 123]    also has ! version


# ITERATING OVER ARRAYS
arr = [1, 2, 3, 4, 5]
new_arr = arr.each { |a| puts a + 5, " "} # Prints out 6, 7, 8, 9, 10, but new_arr = arr, aka doesn't change or create new array
# it just iterates over it
arr.reverse_each { |a| puts "T-#{a}" }
double_arr = arr.map { |a| a*2 } # => [2, 4, 6, 8, 10]    like each, but actually returns modified array
arr.map! { |a| a**2 } # => [1, 4, 9, 16, 25]    ! changed the original
# Another function that does map is collect


# SELECTING ITEMS FROM AN ARRAY
# Non-destructive Selection
arr = [1, 2, 3, 4, 5, 6]
arr.select { |a| a < 4 } # => [1, 2, 3]
arr.reject { |a| a < 4 } # => [4, 5, 6]
arr.drop_while { |a| a < 4  } # => [4, 5, 6]

# Destructive Selection
arr.keep_if { |a| a < 4 } # ! => [4, 5, 6]

arr = [1, 2, 3, 4, 5, 6]
arr.delete_if { |a| a < 4 } # ! => [4, 5, 6]
# delete_if is the equivalent of reject!


# PUBLIC CLASS METHODS
# Array.new(2, Hash.new) vs Array.new(2) { Hash.new }
# The first makes an array of two blank hashes which are the SAME object
# The second one makes two different hashes
Array.try_convert([1]) # => [1]
Array.try_convert("blah") # => nil    Returns nil if not possible to convert to array via .to_ary


# PUBLIC INSTANCE METHODS
[ 'a', 'b', 'b', 'z' ] & [ 'a', 'b', 'c' ] # => ["a", "b"]    pulls out only the shared elements, uniques only
[ 1, 1, 2, 2, 3, 3, 4, 5 ] - [ 1, 2, 4 ] # => [3, 3, 5]     removes second array entries from first, including all duplicates
[1, 2, 3] * 3 # => [1, 2, 3, 1, 2, 3, 1, 2, 3]    array times num = multiples of that array in one
[1, 2, 3] * "," # => "1,2,3"    kind of like a join

a = ["yeah", "cool", "man"]
a + ["I", "know", "right"] # => ["yeah", "cool", "man", "I", "know", "right"]
["yeah", "cool", "man"].concat(["I", "know", "right"]) # => ["yeah", "cool", "man", "I", "know", "right"]   same as Array+

[1, 2] << "cool" << "dude" << [5, 6] # => [1, 2, "cool", "dude", [5, 6]]    could run flatten to make it single layered

[1, 2] <=> [1, 2, 3] # => -1    returns -1, 0, or 1 if first array is less than, equal to, or greater than second array

array_a = ["Top", "Gun", "Maverick"]
array_b = ["Ron", "Burgundy", "Hilarious"]
array_c = "Hangover"
array_of_arrays = [array_a, array_b, array_c]
array_of_arrays.assoc("Ron") # => ["Ron", "Burgundy", "Hilarious"]
array_of_arrays.assoc("Maverick") # => nil    only looks up the first element for a match of each array inside the array
array_of_arrays.rassoc("Gun") # => ["Top", "Gun", "Maverick"]    rassoc looks at the second element of each array inside the array

array_of_arrays.clear # ! => []


a = [1, 2, 3, 4]
a.combination(1).to_a # => [[1], [2], [3], [4]]
a.combination(2).to_a # => [[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]
a.combination(3).to_a # => [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]]
a.combination(4).to_a # => [[1, 2, 3, 4]]
# There is also a repeated combination function

a = [1, 2, 3]
a.permutation.to_a    #=> [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
a.permutation(1).to_a #=> [[1],[2],[3]]
a.permutation(2).to_a #=> [[1,2],[1,3],[2,1],[2,3],[3,1],[3,2]]
a.permutation(3).to_a #=> [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
a.permutation(0).to_a #=> [[]] # one permutation of length 0
a.permutation(4).to_a #=> []   # no permutations of length 4
# There is also a repeated permutation function

[1,2,3].product([4,5])     #=> [[1,4],[1,5],[2,4],[2,5],[3,4],[3,5]]
[1,2].product([1,2])       #=> [[1,1],[1,2],[2,1],[2,2]]
[1,2].product([3,4],[5,6]) #=> [[1,3,5],[1,3,6],[1,4,5],[1,4,6],
                           #     [2,3,5],[2,3,6],[2,4,5],[2,4,6]]
[1,2].product()            #=> [[1],[2]]
[1,2].product([])          #=> []


a.delete(2)	# ! => [1, 3, 4]
a.delete_at(0) # ! => [3, 4]
a.delete_if { |x| x % 3 == 0 } # ! => [4]

a = [1, 2, 3, 4]
a.keep_if { |x| x >= 3 } # ! => [3, 4]

a = [1, 2, 3, 4, 5, 6]
a.drop(3) # => [4, 5, 6]
a.drop_while { |x| x < 3 } # => [3, 4, 5, 6]

a.each { |x| puts x } # => 1 		2 		3 		4 ...
a.each_index { |i| puts i } # => 0 		1 		2 ...
a.each_with_index { |value, index| puts "Value is: #{value}, Index is: #{index}" }

[].empty? # => true
[""].empty?	# => false
# Note: "".empty? # => true

a.fill("x") # ! => ["x", "x", "x", "x", "x", "x"]
a.fill("z", 2, 3) # ! => ["x", "x", "z", "z", "z", "x"]
a.fill("y", 0..1) # ! => ["y", "y", "z", "z", "z", "x"]
a.fill { |i| i*i } # ! => [0, 1, 4, 9, 16, 25]
a.fill(-3) { |i| i*i*i } # ! => [0, 1, 4, 27, 64, 125]

a = ["a", "b", "c", "d", "b"]
a.index("b") # => 1
a.index("z") # => nil
a.index { |x| x == "b" } # => 1
a.rindex("b") # => 4    gives the last index of the given object

a.first # => "a"
a.first(2) # => ["a", "b"]
a.last # => "b"

a = [ 1, 2, [3, [4, 5] ] ]
a.flatten # => [1, 2, 3, 4, 5]
a.flatten(1) # => [1, 2, 3, [4, 5]]
# Has a ! version as well

a.hash # => 1404161586150370747     two arrays with the same content will have the same hash

a = ["a", "b", "c", "d", "b"]
a.include?("a") # => true
a.include?("z") # => false

a = %w{ a b c d }
a.insert(2, 99) # ! => ["a", "b", 99, "c", "d"]
a.insert(-2, 1, 2, 3) # ! => ["a", "b", 99, "c", 1, 2, 3, "d"]

a.to_s #  => "[\"a\", \"b\", 99, \"c\", 1, 2, 3, \"d\"]"
a.join("--") # => "a--b--99--c--1--2--3--d"

a = %w{ a b c d }
a.reverse # => ["d", "c", "b", "a"]
# Has a ! equivalent
a.reverse_each { |x| puts x } # => d 		 c 		 b 		 a

a.rotate # => ["b", "c", "d", "a"]
a.rotate(2) # => ["c", "d", "a", "b"]

a = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
a.sample         #=> 7
a.sample(4)      #=> [6, 4, 2, 5]
# Wonder if this would be better than doing an ActiveRecord grab all, randomize order, pick first

a.shuffle	# => [5, 6, 7, 2, 9, 8, 3, 1, 4, 10]
# Has a ! equivalent

a = [ "d", "a", "e", "c", "b" ]
a.sort                    #=> ["a", "b", "c", "d", "e"]
a.sort { |x,y| y <=> x }  #=> ["e", "d", "c", "b", "a"]
# Has a ! equivalent

a = [[1,2], [3,4], [5,6]]
a.transpose   #=> [[1, 3, 5], [2, 4, 6]]

a = [ "a", "a", "b", "b", "c" ]
a.uniq   # => ["a", "b", "c"]
b = [["student","sam"], ["student","george"], ["teacher","matz"]]
b.uniq { |s| s.first } # => [["student", "sam"], ["teacher", "matz"]]

a = [ 4, 5, 6 ]
b = [ 7, 8, 9 ]
[1, 2, 3].zip(a, b)   #=> [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
[1, 2].zip(a, b)      #=> [[1, 4, 7], [2, 5, 8]]
a.zip([1, 2], [8])    #=> [[4, 1, 8], [5, 2, nil], [6, nil, nil]]