=begin
Your task is to write a CircularQueue class that implements a circular queue for arbitrary objects. The class should obtain the buffer size with an argument provided to CircularQueue::new, and should provide the following methods:

enqueue to add an object to the queue
dequeue to remove (and return) the oldest object in the queue. It should return nil if the queue is empty.
You may assume that none of the values stored in the queue are nil (however, nil may be used to designate empty spots in the buffer).

Problem: keep track of the index of the newest and oldest items added to a circular array

		  All positions are initially empty
X X X
oldest = 0  newest = 0
			Add item
F X X
oldest = 0  newest = 1 
  		Add item
F F X
oldest = 0  newest = 2
		Remove item
X F X
oldest = 1  newest = 2
    Add
X F F
oldest = 1  newest = 0
    Add
F F F       FULL
oldest = 1  newest = 0 
    remove
F X F
oldest = 2  newest = 1
    add
F F F       FULL
oldest = 2   newest = ....UUUUUGGGGHHHHH
4	5	3	Add 5 to the queue, queue is full again
4	5	6	Add 6 to the queue, replaces oldest element (3)
7	5	6	Add 7 to the queue, replaces oldest element (4)
7		6	Remove oldest item from the queue (5)
7			Remove oldest item from the queue (6)
Remove oldest item from the queue (7)
Remove non-existent item from the queue (nil)

=end

require 'pry-byebug'

class CircularQueue
  attr_accessor :length, :queue, :oldest, :newest

  def initialize(length)
    @length = length
    @queue = Array.new(length)
    @newest = 0
    @oldest = 0
  end

def enqueue(obj)
  if queue.any?(nil)
    queue[newest] = obj
    self.newest = (newest + 1) % length
  else 
    queue[newest] = obj
    self.newest = (newest + 1) % length
    self.oldest = (oldest + 1) % length
  end
end

def dequeue
  dequeued_item = queue[oldest]
  queue[oldest] = nil
  unless queue.all?(nil)
    self.oldest = (oldest + 1) % length
  end
  dequeued_item
end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil