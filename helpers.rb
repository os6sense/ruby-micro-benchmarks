
#
# Print usage information
# 
def usage
  puts "Run this program using either:
  ruby benchmark.rb 
or
  rake run_benchmark

Running as a rake task will allow for saving results for analysis using
the rails UI.
"
end


#
# Used to format a header for each "test section"
# 
def header str
  puts str
    .upcase
end

# 
# Very simple class to test class and accors
# 
class Point 
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end
end

# ################################
# TESTS TO HELP IN TESTING RETURN
#
def ret i
  return i
end

def ret_impl i
  i
end

def yield_i i
  yield i
end
# ################################

#
# Used to test Class vs Struct
#
Widget = Struct.new(:id)
point_s = Struct.new(:x, :y)
Point_s = point_s

#
# Used for testing class accessors
#
class TestClass
  attr_reader :ar
  attr_writer :aw
  attr_accessor :aa

  attr_accessor :i
  class << self; attr_accessor :x end
  @@x = 1
  def self.sfoo; end
  def foo; end
end
