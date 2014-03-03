require "benchmark"
require_relative 'constants'
require_relative 'helpers'


# TODO: 

# Save Section info so that it is easier to analyse the final result.
# Save source code line
# Retain checkboxes on UI




# Wrap the bmstore in an ugly begin end otherwise Rails will find SOMETHING
# to complain about if we just try running the benchmark via Ruby. Probably
# should attempt to initialise a connection but I'm already tired of hearing
# Rails opinion.
begin
  require_relative 'bmstore'

  $run_date = Time.zone.now # Monkey patched
rescue Exception
  $run_date = Time.now
end

# Reopen the Benchmark::Report class, manually sending the
# item message (item is aliased to report). After running, store the result
# in the db. This is called ONCE after each benchmark has run.
class Benchmark::Report
  @@warned = false

  def report(label, *format, &block)
    tms = item(label, format, &block)

      SourceLine.new(caller[0])
    begin
      SourceLine.new(caller[0])
      #BMStore.new(label, $run_date, $ruby_version,
                  #SourceLine.new(caller[0]), tms) 
    rescue Exception
      unless @@warned
        puts "** Sorry, could not save benchmark results to rails db." 
        puts "** Try running as a rake task. Further warnings suppressed." 
      end
      @@warned = true
    end
  end
end

def method_calls x
  tc = TestClass.new

  header("method calls")
  x.report("Static Call")       { XLARGE.times { TestClass.sfoo }}
  x.report("Instance Call")     { XLARGE.times { tc.foo }}
  x.report("Send (static)")     { XLARGE.times { tc.send(:foo) }}
  x.report("Send (instance)")   { XLARGE.times { TestClass.send(:sfoo) }}
  x.report("Instance Accessor") { XLARGE.times { tc.i}}
  x.report("class variable")    { XLARGE.times { TestClass.x}}
  x.report("Accessor - r")      { XLARGE.times { tc.ar }}
  x.report("Accessor - rw")     { XLARGE.times { tc.aa }}
  x.report("Accessor - rw")     { XLARGE.times { tc.aa=1 }}
  x.report("Accessor - w")      { XLARGE.times { tc.aw=1 }}
end

# Used to test global access
$global = 1
def comparisons x
  bar = 1
  baz = nil

  header("Comparisons")
  x.report("bool == bool")    { XLARGE.times { |i| true == true } }
  x.report("bool != bool")    { XLARGE.times { |i| true != true } }
  x.report("bool.eql?  bool") { XLARGE.times { |i| true.eql? true } }

  x.report("sym == sym")      { XLARGE.times { |i| :a == :a } }
  x.report("sym != sym")      { XLARGE.times { |i| :a != :a } }
  x.report("sym.eql? sym")    { XLARGE.times { |i| :a.eql? :a } }

  x.report("int == int (fix-global)")    { XLARGE.times { |i| $global == $global } }
  x.report("int != int (fix-global)")    { XLARGE.times { |i| $global == $global } }
  x.report("int.eql? int (fix-global)")  { XLARGE.times { |i| $global.eql? $global } }

  x.report("int == int (fix)")      { XLARGE.times { |i| 1 == 1 } }
  x.report("int != int (fix)")      { XLARGE.times { |i| 1 == 1 } }
  x.report("int.eql? int (fix)")    { XLARGE.times { |i| 1.eql? 1 } }

  x.report("int == int (big)")      { XLARGE.times { |i| BIGNUM == BIGNUM } }
  x.report("int != int (big)")      { XLARGE.times { |i| BIGNUM != BIGNUM } }
  x.report("int.eql? int (big)")    { XLARGE.times { |i| BIGNUM.eql? BIGNUM } }

  x.report("float == float")      { XLARGE.times { |i| 1.0 == 1.0 } }
  x.report("float != float")      { XLARGE.times { |i| 1.0 != 1.0 } }
  x.report("float eql float")     { XLARGE.times { |i| 1.0.eql? 1.0 } }

  x.report("char == char")  { XLARGE.times { |i| 'a' == 'a' } }
  x.report("str == str")    { XLARGE.times { |i| "a" == "a" } }
  x.report("str == char")   { XLARGE.times { |i| "a" == 'a' } }
  x.report("str == sym")    { XLARGE.times { |i| :a == 'a' } }

  x.report("var == nil")    { XLARGE.times { |i| bar == nil } }
  x.report("nil? (false)")  { XLARGE.times { |i| bar.nil? } }
  x.report("nil? (true)")   { XLARGE.times { |i| baz.nil? } }
end

def exceptions x
    header("Exceptions")
    x.report("raise Exception")     { LARGE.times { |i| begin raise Exception; rescue Exception; end } }
    x.report("fail Exception")      { LARGE.times { |i| begin fail Exception; rescue Exception; end } }
    x.report("raise StandardError") { LARGE.times { |i| begin raise StandardError; rescue StandardError; end } }
    x.report("fail StandardError")  { LARGE.times { |i| begin fail StandardError; rescue StandardError; end } }
    x.report("raise (str)")         { LARGE.times { |i| begin raise "Exception"; rescue Exception; end } }
    x.report("fail (str)")          { LARGE.times { |i| begin fail "Exception"; rescue Exception; end } }
end

def containers_aa x
  p1 = Point.new(10, 10)
  p2 = {x: 10, y: 10}
  p3 = Point_s.new(10, 10)

  header("Containers, Accessors & Assignments")
  x.report("class.new:")     { LARGE.times { |i| Point.new(i, i) } }
  x.report("hash {}:")       { LARGE.times { |i| {x: i, y: i} } }
  x.report("struct.new:")    { LARGE.times { |i| Point_s.new(i, i) } }

  header("Accessors")
  x.report("class.x:")       { XLARGE.times { |i| p1.x } }
  x.report("hash[:x]:")      { XLARGE.times { |i| p2[:x]} }
  x.report("hash[\"x\"]:")   { XLARGE.times { |i| p2["x"]} }
  x.report("struct.x:")      { XLARGE.times { |i| p3.x } }
  x.report("struct[:x]:")    { XLARGE.times { |i| p3[:x] } }
  x.report("struct[\"x\"]:") { XLARGE.times { |i| p3["x"] } }
  
  header("Assignments")
  x.report("c.x=:")          { XLARGE.times { |i| p1.x = 20 } }
  x.report("h[:x]=:")        { XLARGE.times { |i| p2[:x] = 20 } }
  x.report("h[\"x\"]=:")     { XLARGE.times { |i| p2["x"] = 20 } }
  x.report("s.x=:")          { XLARGE.times { |i| p3.x = 20 } }
  x.report("foobar ||=:")    { XLARGE.times { |i| foobar ||= 20 } }
  x.report("foobar =:")      { XLARGE.times { |i| foobar = 20 } }
end

def string_ops x
  foo = "foo"
  bar = 1

  header("String Ops")
  x.report("interpolation :")     { ; LARGE.times { |i| " p1 #{foo} and p2 #{bar}" } }
  x.report("concatination + ':")  { LARGE.times { |i| 'p1 ' + foo + ' and p2 ' + bar.to_s } }
  x.report("concatination + \":") { LARGE.times { |i| "p1 " + foo + " and p2 " + bar.to_s } }
  x.report("<< concatination-':") { LARGE.times { |i| 'p1 ' << foo << ' and p2 ' << bar } }
  x.report("<< concatination-\":"){ LARGE.times { |i| "p1 " << foo << " and p2 " << bar } }

  header("String Ops, StringBuilder style (ONLY 20K)")
  x.report("sb interpolation :")    { tmp = ""; (1..20_000).each { |i| tmp = "#{tmp} p1 #{foo} and p2 #{bar}" } }
  x.report("sb concatination +':")  { tmp = ""; (1..20_000).each { |i| tmp += 'p1 ' + foo + ' and p2 ' + bar.to_s } }
  x.report("sb concatination +\":") { tmp = ""; (1..20_000).each { |i| tmp += "p1 " + foo + " and p2 " + bar.to_s } }
  x.report("sb concatination-':")   { tmp = ""; (1..20_000).each { |i| tmp << 'p1 ' << foo << ' and p2 ' << bar } }
  x.report("sb concatination-\":")  { tmp = ""; (1..20_000).each { |i| tmp << "p1 " << foo << " and p2 " << bar } }
end

def enumerable x
  widgets = [].tap { |w| 100.times { |i| w << Widget.new(i) } }

  header("Enumerable")
  x.report("map with to_proc")  { MEDIUM.times { widgets.map(&:id) }}
  x.report("inject")            { MEDIUM.times { widgets.inject([]) {|w, a| w.push(a.id)} }}
  x.report("collect")           { MEDIUM.times { widgets.collect {|w| w.id  }}}
  x.report("map")               { MEDIUM.times { widgets.map {|w| w.id } }}
  x.report("unwound")           { MEDIUM.times { i=0; a = []; while i < 100 do a << widgets[i].id; i+=1; end  }}
end

# helper method so that we dont have to write the same loop 3 times
def loop_helper x, outer, inner
  x.report("while (start) #{inner}:")    { outer.times { |i| i=0; while i < inner do i+=1; end }}
  x.report("while (tail) #{inner}:")     { outer.times { |i| i=0; begin i+= 1 end while i < inner }}
  x.report("until (tail): #{inner}:")    { outer.times { |i| i=0; i+= 1 until i >= inner }}
  x.report("until (start) #{inner}:")    { outer.times { |i| i=0; until i > inner do i+=1 end }}

  x.report("upto #{inner}:")   { outer.times { |i| 0.upto(inner) {} }}
  x.report("times #{inner}:")  { outer.times { |i| inner.times {} }}
  x.report("each #{inner}:")   { outer.times { |i| (0..inner).each {} }}
  x.report("for #{inner}:")    { outer.times { |i| for i in 0..inner do ; end }}
end

def loops x
  header("loops - #{MICRO} iterations")
  loop_helper x, MEDIUM, MICRO

  header("loops - #{SMALL} iterations")
  loop_helper x, SMALL, MEDIUM

  header("loops - #{LARGE} iterations")
  loop_helper x, MICRO, LARGE
end

def return_vs_yield x
  header("return vs yield")
  x.report("return explicit:")  { LARGE.times { |i| ret(i) }}
  x.report("return implicit:")  { LARGE.times { |i| ret_impl(i) }}
  x.report("yield:")            { LARGE.times { |i| yield_i(i) { } }}
end

def logic x
  header("Logic")
  x.report("if (1 term):")          { XLARGE.times { |i| true if true }}
  x.report("if-then-end (1 term):") { XLARGE.times { |i| if true then true end }}
  x.report("if-then-else:")         { XLARGE.times { |i| if true then 1 else 0 end }}
  x.report("?:")                    { XLARGE.times { |i| true ? 1 : 0 }}
  x.report("case:")                 { XLARGE.times { |i| case true when true;1 else;0 end }}
end

def misc x
  header("Miscellanious")
  x.report("mod:")    { XLARGE.times { |i| i % 2 == 0 } }
  x.report("even:")   { XLARGE.times { |i| i.even? }}
end

# run the sweet (tee hee)
def run_benchmarks(ruby_version=nil)

  if ruby_version
    $ruby_version = ruby_version
  else
    $ruby_version = RUBY_VERSION
  end

  usage

  Benchmark.bm(25) do |x|
    containers_aa x
    loops x
    method_calls x
    comparisons x
    exceptions x
    string_ops x
    enumerable x
    return_vs_yield x
    logic x
    #  : vs =>
  end
end

# Run the benchmarks if called directly
if __FILE__ == $0
  run_benchmarks
end

