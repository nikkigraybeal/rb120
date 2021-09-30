=begin
class Cat
  @@cat_quantity = 0

  attr_accessor :name

  def initialize(name)
    @name = name
    @@cat_quantity += 1
  end

  def self.total
    puts @@cat_quantity
  end

  def self.generic_greeting
    puts "Hello, I'm a cat!"
  end

  def rename(name)
    self.name = name
  end

  def identify
    self
  end

  def personal_greeting
    puts "Hello, my name is #{name}!"
  end
end

kitty1 = Cat.new("Sophie")
kitty2 = Cat.new("Chloe")
Cat.total


class Cat
  COLOR = "black"
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end

  def greet
    puts "Hi, my name is #{name} and I'm a #{COLOR} cat!"
  end

end

kitty = Cat.new("Sophie")
kitty.greet


class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "I'm #{name}"
  end  
end

kitty = Cat.new('Sophie')
puts kitty


class Person
  def secret
    @secret
  end

  def secret=(secret)
    @secret = secret
  end
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
puts person1.secret


class Person
  attr_writer :secret

  private

  attr_reader :secret

  public

  def share_secret
    puts secret
  end
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
person1.share_secret
=end


class Person
  attr_writer :secret

  def compare_secret(person2)
    secret == person2.secret
  end

  protected

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'

person2 = Person.new
person2.secret = 'Shh.. this is a different secret!'

puts person1.compare_secret(person2)