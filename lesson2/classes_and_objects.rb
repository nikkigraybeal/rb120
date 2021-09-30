=begin
# Given the below usage of the Person class, code the class definition.

class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

class Person
  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def name=(name)
    @name = name
  end
end

class Being
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

class Person < Being
end

class Being 
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

class Person < Being
  attr_accessor :lifespan
  def initialize(lifespan, name)
    super(name)
    @lifespan = lifespan
  end
end
    

bob = Person.new(72, 'bob')
puts bob.name                  # => 'bob'
bob.name = 'Robert'
puts bob.name                  # => 'Robert'
puts bob.lifespan

# Modify the class definition from above to facilitate the following methods. Note that there is no name= setter method now.

class Person
  attr_writer :last_name
  attr_reader :first_name, :last_name

  def initialize(name)
    @first_name = name
    @last_name = ''
  end

  def name
    "#{first_name} #{last_name}".strip
  end
end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'


# Now create a smart name= method that can take just a first name or a full name, and knows how to set the first_name and last_name appropriately.

class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name=(name)
    parse_full_name(name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  private
  def parse_full_name(full_name)
    parts = full_name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end


bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
p bob.first_name            # => 'John'
p bob.last_name             # => 'Adams'
=end

class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name=(name)
    parse_full_name(name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def to_s
    name
  end

  private
  def parse_full_name(full_name)
    parts = full_name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end

# Using the class definition from step #3, let's create a few more people -- that is, Person objects.

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

# If we're trying to determine whether the two objects contain the same name, how can we compare the two objects?

puts bob.name == rob.name ? "they're the same" : "they're different"

puts bob
