module Enumerable
  # each implementation using a 'for' loop
  def my_each
    for e in self
      yield(e)
    end
  end

  # each_with_index implementation using my_each and an index counter
  def my_each_with_index
    i = 0
    self.my_each do |e|
      yield(e, i)
      i += 1
    end
  end

  # select implementation using my_each
  def my_select
    result = []

    self.my_each do |e|
      if yield(e)
        result << e
      end
    end

    return result
  end

  # all? implementation using a for loop
  def my_all?(&condition)
    return false if condition.nil?
        
    for e in self
      return false unless yield(e)
    end

    return true
  end

  # any? implementation using a for loop - inverse of my_all?
  def my_any?(&condition)
    return true if condition.nil?

    for e in self
      return true if yield(e)
    end

    return false
  end

  # none? implemented using a for loop and default Proc object
  def my_none?(&condition)
    condition ||= Proc.new { |e| e }

    for e in self
      return false if condition.call(e)
    end

    return true
  end

  # count implemented using default arguments and a for loop
  def my_count(match = (no_arg = true; nil), &condition)
    if condition.nil?
      if no_arg
        condition = Proc.new { true }
      else
        condition = Proc.new { |e| e == match }
      end
    end

    count = 0
    for e in self
      if condition.call(e)
        count += 1
      end
    end

    return count
  end

  # map implemented using my_each
  def my_map(proc = nil, &block)
    result = []

    if proc
      self.my_each { |e| result << proc.call(e) }
    else
      self.my_each { |e| result << block.call(e) }
    end

    return result
  end

  # inject implemented using my_map
  def my_inject(first = nil, second = nil, &block)
    arr = self.to_a
    result = nil

    if !second && !block
      result = arr[0]

      arr[1..-1].my_map { |e| result = result.send(first, e) }
    elsif !first && !second
      result = arr[0]

      arr[1..-1].my_map { |e| result = block.call(result, e) }
    elsif !second
      result = first

      arr.my_map { |e| result = block.call(result, e) }
    else
      result = first

      arr.my_map { |e| result = result.send(second, e) }
    end

    return result
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end
