# Hashes are key-value pairs.
# Keys can be represented by a string or symbol.
# Standard is symbol and is also faster.
grades = { "Jane Doe" => 10, "John Doe" => 9}
options = { font_size: 12, font_family: "Arial" }

# Set a default
grades = Hash.new(0)
grades.default # => 0
grades.default = "hey"
grades[:sup] # => "hey"

# If a hash is the argument, you can use () instead of {}
Person.create(name: "Gerry", age: 27)

def self.create(params)
	@name = params[:name]
	@age =  params[:age]
end


# PUBLIC CLASS METHODS
Hash["a", 100, "b", 200]             #=> {"a"=>100, "b"=>200}
Hash[ [ ["a", 100], ["b", 200] ] ]   #=> {"a"=>100, "b"=>200}
Hash["a" => 100, "b" => 200]         #=> {"a"=>100, "b"=>200}

# Try to convert a given obj to a hash via .to_hash
Hash.try_convert({1=>2})   # => {1=>2}
Hash.try_convert("1=>2")   # => nil


# PUBLIC INSTANCE METHODS
# == is equal when all key-value pairs are equal. Same thing as h2.eql?(h3)
h1 = { "a" => 1, "c" => 2 }
h2 = { 7 => 35, "c" => 2, "a" => 1 }
h3 = { "a" => 1, "c" => 2, 7 => 35 }
h4 = { "a" => 1, "d" => 2, "f" => 35 }
h1 == h2   #=> false
h2 == h3   #=> true
h3 == h4   #=> false

# Element Assignment
h = {colors: ["red", "blue", "green"],
     "letters" => ["a", "b", "c" ]}
h[:colors] # => ["red", "blue", "green"]
h.assoc(:colors) # => [:colors, ["red", "blue", "green"]]
h.assoc("foo")   #=> nil
h.rassoc(["a", "b", "c" ]) # => ["letters", ["a", "b", "c"]]

h.clear # => {}
h.delete("letters") # !
h.delete("letters") { |key| puts "#{key} not found"} # => nil     block is executed if it does not exist
h = { "a" => 100, "b" => 200, "c" => 300 }
h.delete_if {|key, value| key >= "b" }   # ! => {"a"=>100}
# For a non ! version, use reject
h.keep_if { |key, value| key == "a" }    # ! => {"a"=>100}
# For a non ! version, use select

h = { "a" => 100, "b" => 200 }
h.each {|key, value| puts "#{key} is #{value}" } # => a is 100     b is 200      alias: each_pair
h.each_key { |key| puts "#{key}" } # => a     b
h.each_value { |value| puts "#{value}" } # => 100     200

{}.empty? # => true

# Fetch grabs the value, returns a default value, or does a block on the key
h.fetch("a")                            #=> 100
h.fetch("z", "go fish")                 #=> "go fish"
h.fetch("z") { |el| "go fish, #{el}"}   #=> "go fish, z"

# Similar to Array#flatten, Hash#flatten first converts to an array, that flattens.
a =  {1=> "one", 2 => [2,"two"], 3 => "three"}
a.flatten    # => [1, "one", 2, [2, "two"], 3, "three"]
a.flatten(2) # => [1, "one", 2, 2, "two", 3, "three"]

h.has_key?("a") # => true				alias: h.include?("a")
h.has_key?("z") # => false
h.has_value?(100) # => true
h.has_value?(999) # => false
h.key(100) # => "a"
h.keys # => ["a", "b"]
h.values # => [100, 200]
h.values_at("a", "b") # => [100, 200]

h.to_s # => "{\"a\"=>100, \"b\"=>200}"
h.to_a # => [["a", 100], ["b", 200]]

h.invert # => {100=>"a", 200=>"b"}

h.length # => 2

# Merge will integrate new hash, overwriting old hash values for keys that already exist
# Merge has a ! equivalent as well
# This can be useful if you're doing a lot of different Time.strftime commands as you can
# create a file that runs Time.merge! and input custom-named strftimes
h1 = { "a" => 100, "b" => 200 }
h2 = { "b" => 254, "c" => 300 }
h1.merge(h2)   #=> {"a"=>100, "b"=>254, "c"=>300}
h1.merge(h2){|key, oldval, newval| newval - oldval}
               #=> {"a"=>100, "b"=>54,  "c"=>300}
h1             #=> {"a"=>100, "b"=>200}
