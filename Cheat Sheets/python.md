# Python Cheat Sheet

## Basics

### Variables and Data Types

- Integer: `int(x)`
- Float: `float(x)`
- String: `str(x)`
- Boolean: `bool(x)`
- List: `[...]`
- Tuple: `(...)`
- Dictionary: `{...}`

### Operators

- Arithmetic: `+`, `-`, `*`, `/`, `//`, `%`
- Comparison: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Logical: `and`, `or`, `not`
- Assignment: `=`, `+=`, `-=`, `*=`, `/=`, `//=`, `%=` 

### Control Flow

- If statement: `if condition:`
- Else statement: `else:`
- Elif statement: `elif condition:`
- While loop: `while condition:`
- For loop: `for item in iterable:`

### Functions

- Define a function: `def function_name(parameters):`
- Call a function: `function_name(arguments)`

## Intermediate

### List Manipulation

- Accessing elements: `list[index]`
- Slicing: `list[start:end:step]`
- Appending: `list.append(item)`
- Removing: `list.remove(item)`

### String Manipulation

- Concatenation: `string1 + string2`
- Formatting: `f"{variable}"`
- Methods: `string.method()`

### File Handling

- Opening a file: `open("filename", "mode")`
- Reading from a file: `file.read()`
- Writing to a file: `file.write()`

## Advanced

### Object-Oriented Programming

- Class definition: `class ClassName:`
- Constructor method: `def __init__(self, parameters):`
- Instance methods: `def method_name(self, parameters):`

### Exception Handling

- Try block: `try:`
- Except block: `except ExceptionType as e:`
- Finally block: `finally:`

### Modules and Packages

- Importing modules: `import module_name`
- Importing specific functions: `from module_name import function_name`
- Creating packages: `__init__.py`

### Decorators

- Defining a decorator: `def decorator(func):`
- Applying a decorator: `@decorator`

### Generators and Iterators

- Generator functions: `def generator_function():`
- Yield statement: `yield item`
- Iterating over generators: `for item in generator_function():`

### List Comprehensions

- Creating lists: `[expression for item in iterable if condition]`
- Nested list comprehensions

### Lambda Functions

- Creating anonymous functions: `lambda parameters: expression`

### Regular Expressions

- Matching patterns: `import re`, `re.match(pattern, string)`
- Search and replace: `re.search(pattern, string)`, `re.sub(pattern, replacement, string)`

### Context Managers

- Using the `with` statement: `with open("file.txt", "r") as file:`

### Concurrency and Parallelism

- Threading: `import threading`
- Multiprocessing: `import multiprocessing`

### Virtual Environments

- Creating virtual environments: `python -m venv myenv`
- Activating virtual environments: `source myenv/bin/activate`

### Package Management

- Installing packages: `pip install package_name`
- Managing dependencies: `pip freeze`, `pip install -r requirements.txt`

### Generators and Iterators

- Generator functions: `def generator_function():`
- Yield statement: `yield item`
- Iterating over generators: `for item in generator_function():`

### List Comprehensions

- Creating lists: `[expression for item in iterable if condition]`
- Nested list comprehensions

### Lambda Functions

- Creating anonymous functions: `lambda parameters: expression`

### Regular Expressions

- Matching patterns: `import re`, `re.match(pattern, string)`
- Search and replace: `re.search(pattern, string)`, `re.sub(pattern, replacement, string)`

### Context Managers

- Using the `with` statement: `with open("file.txt", "r") as file:`

### Concurrency and Parallelism

- Threading: `import threading`
- Multiprocessing: `import multiprocessing`

### Virtual Environments

- Creating virtual environments: `python -m venv myenv`
- Activating virtual environments: `source myenv/bin/activate`

### Package Management

- Installing packages: `pip install package_name`
- Managing dependencies: `pip freeze`, `pip install -r requirements.txt`

## Further Advanced

### Metaprogramming

- Dynamically generating or modifying Python code at runtime.

### Descriptors

- Understanding and implementing descriptors for attribute access control.

### Memory Management

- Understanding Python's memory management and using tools like `gc` module.

### Closures and Decorators

- Deep dive into closures and advanced decorator patterns.

### Concurrency Libraries

- Exploring advanced concurrency libraries like asyncio, Trio, or Curio.

### Performance Optimization

- Techniques for optimizing Python code for speed and memory usage.

### Debugging and Profiling

- Using tools like pdb, cProfile, or line_profiler for debugging and profiling Python code.

### Extension Modules

- Writing and using C extensions or Cython for performance-critical parts of Python code.

### Web Development

- Advanced topics in web development using frameworks like Django or Flask, including RESTful APIs, authentication, and deployment strategies.