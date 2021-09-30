=begin
class SecurityLogger
  attr_accessor :log

  def initialize
    @log = []
  end

  def create_log_entry
    self.log << "data access date: #{date}"
  end

  def date
    Time.now
  end
end


class SecretFile
  attr_accessor :security_log

  def initialize(secret_data)
    @data = secret_data
    @security_log = SecurityLogger.new
  end

  def data
    security_log.create_log_entry
    @data
  end
end

secret_stuff = SecretFile.new("Shhh...it's a secret")
puts secret_stuff.data
puts secret_stuff.security_log.log
puts secret_stuff.data
puts secret_stuff.security_log.log 
=end

module Moveable
  attr_accessor :speed, :heading
  attr_writer :fuel_capacity, :fuel_efficiency

  def range
    "Range: #{@fuel_capacity * @fuel_efficiency} km"
  end

  def efficiency
    "Your #{self.class} gets #{@fuel_efficiency} km per liter of fuel"
  end
end

class WheeledVehicle
  include Moveable 

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

class Seacraft
  include Moveable
  attr_reader :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    @propeller_count = num_propellers
    @hull_count = num_hulls
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def range
    "Range: #{(@fuel_capacity * @fuel_efficiency) + 10} km"
  end

end

class Catamaran < Seacraft
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    super(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end

class Motorboat < Seacraft
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    super(1, 1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end


car = Auto.new
harley = Motorcycle.new
boat = Catamaran.new(2, 2, 40, 70.0)
speed_boat = Motorboat.new(50, 15.0)
puts car.range
puts car.efficiency
puts harley.range
puts harley.efficiency
puts boat.range
puts boat.efficiency
puts speed_boat.range
puts speed_boat.efficiency



