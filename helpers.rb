 
def header str
  puts str
    .upcase
end

class Point 
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end
end

def ret(i)
  return i
end

def ret_impl(i)
  i
end

def yield_i(i)
  yield i
end

Widget = Struct.new(:id)
point_s = Struct.new(:x, :y)
Point_s = point_s

MICRO = 100
SMALL = 1_000
MIDS = 10_000
MEDIUM = 100_000
LARGE = 1_000_000
XLARGE = 10_000_000

class TestClass
  attr_accessor :i
  def self.sfoo

  end

  def foo
  end

end


# I could bm like this but I add the overhead of the .call
#bm_run(x, MEDIUM, ["map_with_to_proc", ->{ widgets.map(&:id) } ])
#def bm_run(bm, loop_size, m)
   #bm.report(m[0]) { (1..loop_size).each { m[1].call } }
#end
