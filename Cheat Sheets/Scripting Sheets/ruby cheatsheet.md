# Ruby Cheat Sheet

## Variables
Variables store data that can be referenced and manipulated.

```ruby
name = "John"    # Assigning a string value to the variable 'name'
age = 30         # Assigning an integer value to the variable 'age'
```

## Data Types
Ruby supports various data types to represent different kinds of information.

### String
```ruby
name = "John"     # A sequence of characters
```
### Integers
```ruby
age = 30          # Whole Numbers
```

### Float
```ruby
weight = 65.5     # Numbers with decimal points
```

### Booleans
```ruby
is_student = true # Assigning true/false statements
```

### Arrays
```ruby
numbers = [1,2,3] # Ordered collection of elements
```

### Hash
```ruby
person = {"name" => "John","age" => 30} # A collection of key-value pairs
```

## Control Structures
- Control structures manage the flow of execution

### Conditional statements

#### IF Statements
- codeblock executes if condition equals true.
```ruby
if XYZ = true then
```

#### ElseIF Statements
- codeblock executes if condition equals true
```ruby
if XYZ = false then
    elseif XYZ = true then
```
#### Else
- codeblock executes if condition equals false
```ruby
if XYZ = false then
else ...
```

# Loops

#### While Loops
- codeblock executes repeatedly while condition = true
```ruby
While XYZ = true do ZYX
```

#### For Loops
- codeblock executes for each item in array
```ruby
array.each do | item |
```
# Methods
- Methods are reusable blocks of code.

example codeblock:
```ruby
def greet(name)
    puts "Hello, #{name}!"
# This function greets a person
```
we define greet as a method and name as the argument.

# Classes
- Classes are blueprints for creating objects.

```ruby
class Person
    attr_accessor :name, :age # Defining attributes 'name' and 'age'

def initialize(name, age)
    @name = name # Initializing object with name
    @age = age # Initializing object with age
end

def greet
    puts "Hello,#{@name}!" # A method to greet a person
    end
end

person = Person.new("John",30) # Creating a new Person object
person.greet # Calling the greet method on the person object
```

# File I/O
- File I/O operations involve reading and writing to files

#### Reading from file
```ruby
File.open("file.txt","r") do |file|
    puts file.read # Reading and outputting contents of file
end
```

#### Writing to file
```ruby
File.open("file.txt","w") do |file|
    file.write("Hello!") # Writing to a text file
end
```
# Exception Handling
- Exception handling deals with managing errors an exceptions
```ruby
begin
# Code that might produce an error when executed
rescue ExceptionType => e
    # Code to handle the exception
end
```

# Comments
- Useful for providing explanation to code
```ruby
# This is a single line comment
=begin

this is a
multi-line
comment

=end
```

# Rubygems