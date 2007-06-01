require 'enumerator'

class Fixnum
  def factorial
    (1..self).inject(1) { |n,i| n*i }
  end
  
  def choose(i)
    return nil if (self < 0 || i < 0)
    case self <=> i
      when -1: 0
      when 0: 1
      when 1: self.factorial / (i.factorial * (self-i).factorial)
    end
  end
end

class Array
	def combinations(n)
		n=self.size if n > self.size
		
		return if n==0

		if n == self.size then
			if block_given? then 
				yield self 
				return
			else 
				return [self]
			end
		end	
	
		if n == 1 then
			if block_given? then
				self.each { |i| yield [i] }
				return
			else
				d=[]
				self.each { |i| d.push([i]) }	
				return d
			end	
		end

		d=[]
		self.each_index { |i|
			b=self.dup
			c=b.delete_at(i)
			b.combinations(n-1) {|x|
				m=[c, x].flatten.sort
				d.push(m)
			}
		}
		if block_given? then
			d.uniq.each {|i| yield i }
		else
			return d.uniq
		end
	end
end

module Combinatorial
  attr_accessor :solutions, :max_score
    
  def initialize_set(set,k,solutions=Array.new)
    @set = set
    @k = k
    @solutions = solutions
    @max_score = (@set.length/@k) * @k.choose(2) + 1
    @set
  end
  
  def add_set(set)
    @solutions << set
  end
  
  def random
    # get random permutation
    p = Permutation.new(@set.length).random.value
    # slice it into kSets,  expanded from p.enum_slice(@k).map
    p.enum_slice(@k).inject(Kset.new(self)) do |set,slice| 
      set << slice.collect { |i| @set[i] }
      set 
    end                                              
  end
  
  def solve
    max_loops = 2000
    best = Kset.new(self)
    
    max_loops.times do
      p = random
      if p.score == 0
        best = p
        break
      end
      if p.score < @max_score
        best = p
        @max_score = p.score
      end
    end
    best
  end
  
  class Kset < Array

    def initialize(parent)
      @parent = parent
    end
    
    def +(array)
      array.each { |i| self << i }
      self
    end

    def score
      count = 0
      map do |set|
        @parent.solutions.inject(0) do |tally,s|
          t = (s & set).length
          n = (t > 1 ? t.choose(2) : 0)
          count += n
          # short circuit if it's a known failure
          return @parent.max_score + 1 if count > @parent.max_score
          # otherwise keep counting
          tally + n
        end
      end.inject(0) { |score,n| score + n }
    end

    def bind
      each { |s| @parent.add_set(s) }
    end
  end
end