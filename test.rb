module Maintenance
  def change_tires
    puts "Changing #{Car::WHEELS} tires."
  end
end

class Vehicle
  WHEELS = 4
end

class Car < Vehicle
  include Maintenance
end

a_car = Car.new

a_car.change_tires       