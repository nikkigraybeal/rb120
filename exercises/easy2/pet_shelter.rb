
class Pet
  attr_reader :type, :pet_name
  attr_accessor :adopted
  @@pets = []

  def initialize(type, pet_name)
    @type = type
    @pet_name = pet_name
    @@pets << self
  end

end

class Owner
  attr_reader :name
  attr_accessor :pets
  
  def initialize(name)
    @name = name
    @pets = []
  end

  def number_of_pets
    pets.size
  end
end

class Shelter < Pet
  def initialize
    @adoptions = {}
  end

  def adopt(owner_obj, pet_obj)
     owner_obj.pets << pet_obj
     @adoptions[owner_obj.name] = owner_obj.pets
  end

  def print_adoptions
    @adoptions.each do |owner_name, pet_arr|
      puts "#{owner_name} has adopted the following pets:"
      pet_arr.each do |pet_obj|
        puts "a #{pet_obj.type} named #{pet_obj.pet_name}"
      end
    end
  end

  def print_available_pets
    adopted = @adoptions.values.flatten
    puts "The Animal Shelter has the following unadopted pets:"
    @@pets.each do |pet_obj|
      puts "A #{pet_obj.type} named #{pet_obj.pet_name}" if !adopted.include?(pet_obj)
    end
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
moshie       = Pet.new('cat', 'Moshie')
hally        = Pet.new('hamster', 'Hally')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')
ngraybeal = Owner.new('N Graybeal')

shelter = Shelter.new
shelter.adopt(ngraybeal, moshie)
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "#{ngraybeal.name} has #{ngraybeal.number_of_pets} adopted pets."

shelter.print_available_pets

=begin
problem: create a class structure to produce the correct output.
superclass: Shelter
  methods: adopt(owner, pet) (assigns pet to owner)
           print_adoptions   (prints all owners and list of their pets)
subclass: Owner(name)
  methods: number_of_pets (increment every time adopt is called?)
subclass: Pet(type, name)

Write the classes and methods that will be necessary to make this code run, and print the following output:

Copy Code
P Hanson has adopted the following pets:
a cat named Butterscotch
a cat named Pudding
a bearded dragon named Darwin

B Holmes has adopted the following pets:
a dog named Molly
a parakeet named Sweetie Pie
a dog named Kennedy
a fish named Chester

P Hanson has 3 adopted pets.
B Holmes has 4 adopted pets.
The order of the output does not matter, so long as all of the information is presented.
=end