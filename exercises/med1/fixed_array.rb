# A fixed-length array is an array that always has a fixed number of elements. Write a class that implements a fixed-length array, and provides the necessary methods to support the following code:

class FixedArray
  attr_accessor :elements, :arr

  def initialize(elements)
    @elements = elements
    @arr = create_array
  end

  def create_array
    new_arr = []
     elements.times do
      new_arr << nil
     end
     new_arr
  end

  def []=(index, value)
    raise IndexError.new unless (0..elements - 1).include?(index) || (-elements..-1).include?(index)
    arr[index] = value
  end

  def [](index)
    raise IndexError.new unless (0..elements - 1).include?(index) || (-elements..-1).include?(index)
    arr[index] 
  end

  def to_a
    arr.clone
  end

  def to_s
    arr.to_a.to_s
  end
end

fixed_array = FixedArray.new(5)

puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end
# The above code should output true 16 times.

