class Vehicle
  @@total_vehicles = 0

  attr_accessor :color
  attr_reader :year

  def initialize(y , c, model)
    @year = y 
    @color = c 
    @model = model
    @speed = 0
    @@total_vehicles += 1
  end

  def self.vehicle_count
    @@total_vehicles
  end

  def speed_up(number)
    @speed += number
  end

  def break(number)
    @speed -= number
  end

  def turn_off
    @speed = 0
  end

  def speed
    puts "#{@speed}"
  end

  def self.mileage(miles, gallons)
    miles / gallons
  end

  def spray_paint
    puts "enter a color"
    answer = gets.chomp
    self.color = answer
  end

  private
  def age
    Time.now.year - self.year.to_i
  end

  public
  def display_age
    age
  end
end

module Loadable
  def gather_items(item1, item2, item3)
    puts "#{item1}, #{item2} and #{item3} have been gathered."
  end

  def load_items(item1, item2, item3)
    puts "#{item1}, #{item2} and #{item3} have been loaded into the truck."
  end
end

class MyCar < Vehicle
  GVW = (0...1999)
  def initialize(y, c, model)
    super(y, c, model) 
  end

  def to_s
    "My car is a #{year}, #{color} #{@model} and is going #{@speed} miles per hour."
  end
end

class MyTruck < Vehicle
  GVW = (2000..10000)
  include Loadable
  def initialize(y, c, model, tow_cap)
    super(y, c, model)
    @tow_cap = tow_cap
  end

  def to_s
    "My truck is a #{year}, #{color} #{@model} and is going #{@speed} miles per hour."
  end
end

tacoma = MyTruck.new("2018", "black", "Tacoma", "350")
p tacoma

camry = MyCar.new("2013", "silver", "Camry")
camry.speed_up(20)
camry.break(10)
puts camry.speed
camry.break(5)
camry.speed_up(50)
puts camry.speed
camry.turn_off
puts camry.speed
camry.color = "pink"
puts camry.color
camry.spray_paint
puts camry.color
puts camry

tacoma.gather_items("couch", "lamp", "armchair")
tacoma.load_items("couch", "lamp", "armchair")

p Vehicle.vehicle_count

p MyTruck.ancestors
p MyCar.ancestors
p Vehicle.ancestors

p tacoma.display_age
p camry.display_age

class Student
  attr_accessor :name
  attr_reader :grade
  private
  attr_writer :grade

  public
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(student)
    self.grade > student.grade ? true : false
  end
end

joe = Student.new("Joe", 98)
bob = Student.new("Bob", 74)

puts "Well done, Joe!" if joe.better_grade_than?(bob)

bob.grade = 99