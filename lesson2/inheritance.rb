=begin
class Dog
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

teddy = Bulldog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"

# One problem is that we need to keep track of different breeds of dogs, since they have slightly different behaviors. For example, bulldogs can't swim, but all other dogs can.

# Create a sub-class from Dog called Bulldog overriding the swim method to return "can't swim!"
=end

class Animal
  def speak
    if self.class == Dog
      'bark!'
    elsif self.class == Cat
      'meow!'
    else
      "can't speak!"
    end
  end

  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Animal
  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Animal
  
end

class Bulldog
  def swim
    "can't swim!"
  end
end


# Create a new class called Cat, which can do everything a dog can, except swim or fetch. Assume the methods do the exact same thing. Hint: don't just copy and paste all methods in Dog into Cat; try to come up with some class hierarchy.

kitty = Cat.new
puts kitty.speak
puts kitty.run

puppy = Dog.new
puts puppy.speak
puts puppy.fetch
puts puppy.jump

morgan = Animal.new
puts morgan.speak

goober = Bulldog.new
puts goober.swim