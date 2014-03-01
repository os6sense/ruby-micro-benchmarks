require "benchmark"
require_relative 'helpers'

p1 = Point.new(10, 10)
p2 = {x: 10, y: 10}
p3 = Point_s.new(10, 10)

bar = 1
baz = nil
foo = "foo"

widgets = [].tap { |w| (1..100).each { |i| w << Widget.new(i) } }

tc = TestClass.new

BIGNUM = 999_999_999_999_999_999_999


class BMStore
  def self.store(label, list)
    # Benchmark::Tms
    puts list.class
  end
end

class Benchmark::Report
  def report(label, *format, &block)
    tmd = item(label, format, &block)
    BMStore.store(label, tms)
  end
end

Benchmark.bm(20) do |x|
  puts "NOTE tests marked with *: "
  puts "These benchmarks use a different size to the others in the
  group for performance reasons"

  header("Exceptions")
  x.report("raise Exception")  { (1..LARGE).each { |i| begin raise Exception; rescue Exception; end } }
  x.report("fail Exception")  { (1..LARGE).each { |i| begin fail Exception; rescue Exception; end } }
  x.report("raise StandardError")  { (1..LARGE).each { |i| begin raise StandardError; rescue StandardError; end } }
  x.report("fail StandardError")  { (1..LARGE).each { |i| begin fail StandardError; rescue StandardError; end } }
  x.report("raise (str)")  { (1..LARGE).each { |i| begin raise "Exception"; rescue Exception; end } }
  x.report("fail (str)")  { (1..LARGE).each { |i| begin fail "Exception"; rescue Exception; end } }

  header("Comparisons")
  x.report("bool == bool")  { (1..XLARGE).each { |i| true == true } }
  x.report("bool != bool")  { (1..XLARGE).each { |i| true != true } }
  x.report("bool.eql?  bool")  { (1..XLARGE).each { |i| true.eql? true } }

  x.report("sym == sym")    { (1..XLARGE).each { |i| :a == :a } }
  x.report("sym != sym")    { (1..XLARGE).each { |i| :a != :a } }
  x.report("sym.eql? sym")    { (1..XLARGE).each { |i| :a.eql? :a } }

  x.report("int == int (fix)")    { (1..XLARGE).each { |i| 1 == 1 } }
  x.report("int != int (fix)")    { (1..XLARGE).each { |i| 1 == 1 } }
  x.report("int.eql? int (fix)")    { (1..XLARGE).each { |i| 1.eql? 1 } }

  x.report("int == int (big)")    { (1..XLARGE).each { |i| BIGNUM == BIGNUM } }
  x.report("int != int (big)")    { (1..XLARGE).each { |i| BIGNUM != BIGNUM } }
  x.report("int.eql? int (big)")    { (1..XLARGE).each { |i| BIGNUM.eql? BIGNUM } }

  x.report("float == float")    { (1..XLARGE).each { |i| 1.0 == 1.0 } }
  x.report("float != float")    { (1..XLARGE).each { |i| 1.0 != 1.0 } }
  x.report("float eql float")    { (1..XLARGE).each { |i| 1.0.eql? 1.0 } }


  x.report("char == char")  { (1..XLARGE).each { |i| 'a' == 'a' } }
  x.report("str == str") {  (1..XLARGE).each { |i| "a" == "a" } }
  x.report("str == char") {  (1..XLARGE).each { |i| "a" == 'a' } }
  x.report("str == sym") {  (1..XLARGE).each { |i| :a == 'a' } }

  x.report("var == nil")  { (1..XLARGE).each { |i| bar == nil } }
  x.report("nil? (false)")  { (1..XLARGE).each { |i| bar.nil? } }
  x.report("nil? (true)")   { (1..XLARGE).each { |i| baz.nil? } }




  header("Containers/Constructors")
  x.report("class:")    { (1..LARGE).each { |i| Point.new(i, i) } }
  x.report("hash:")     { (1..LARGE).each { |i| {x: i, y: i} } }
  x.report("struct:")   { (1..LARGE).each { |i| Point_s.new(i, i) } }

  header("Accessors")
  x.report("class.x:")      { (1..XLARGE).each { |i| p1.x } }
  x.report("hash[:x]:")    { (1..XLARGE).each { |i| p2[:x]} }
  x.report("hash[\"x\"]:") { (1..XLARGE).each { |i| p2["x"]} }
  x.report("struct.x:")      { (1..XLARGE).each { |i| p3.x } }
  x.report("struct[:x]:")    { (1..XLARGE).each { |i| p3[:x] } }
  x.report("struct[\"x\"]:") { (1..XLARGE).each { |i| p3["x"] } }

  header("method calls")
  x.report("Static Call")  { (1..XLARGE).each { TestClass.sfoo }}
  x.report("Instance Call")  { (1..XLARGE).each { tc.foo }}
  x.report("Send (static)")  { (1..XLARGE).each { tc.send(:foo) }}
  x.report("Send (instance)")  { (1..XLARGE).each { TestClass.send(:sfoo) }}
  x.report("Instance Attribute")  { (1..XLARGE).each { tc.i}}

  header("String Ops")
  x.report("* interpolation :")      { ; (1..LARGE).each { |i| " p1 #{foo} and p2 #{bar}" } }
  x.report("* + concatination-':")  { (1..LARGE).each { |i| 'p1 ' + foo + ' and p2 ' + bar.to_s } }
  x.report("* + concatination-\":") { (1..LARGE).each { |i| "p1 " + foo + " and p2 " + bar.to_s } }
  x.report("<< concatination-':")   { (1..LARGE).each { |i| 'p1 ' << foo << ' and p2 ' << bar } }
  x.report("<< concatination-\":")  { (1..LARGE).each { |i| "p1 " << foo << " and p2 " << bar } }

  header("String Ops, StringBuilder style- READ NOTES!")
  x.report("* interpolation :")      { tmp = ""; (1..20_000).each { |i| tmp = "#{tmp} p1 #{foo} and p2 #{bar}" } }
  x.report("* + concatination-':")  { tmp = ""; (1..20_000).each { |i| tmp += 'p1 ' + foo + ' and p2 ' + bar.to_s } }
  x.report("* + concatination-\":") { tmp = ""; (1..20_000).each { |i| tmp += "p1 " + foo + " and p2 " + bar.to_s } }
  x.report("<< concatination-':")   { tmp = ""; (1..20_000).each { |i| tmp << 'p1 ' << foo << ' and p2 ' << bar } }
  x.report("<< concatination-\":")  { tmp = ""; (1..20_000).each { |i| tmp << "p1 " << foo << " and p2 " << bar } }

  #  : vs =>
  header("Enumerable")
  x.report("map with to_proc")  { (1..MEDIUM).each { widgets.map(&:id) }}
  x.report("inject")  { (1..MEDIUM).each { widgets.inject([]) {|w, a| w.push(a.id)} }}
  x.report("collect")  { (1..MEDIUM).each { widgets.collect {|w| w.id  }}}
  x.report("map")  { (1..MEDIUM).each { widgets.map {|w| w.id } }}

  header("loops - #{MICRO} iterations")
  x.report("while (start):")  { (1..MEDIUM).each { |i| i=0; while i < MICRO do i+=1; end }}
  x.report("while: (tail)")  { (1..MEDIUM).each { |i| i=0; begin i+= 1 end while i < MICRO }}
  x.report("until (tail):")  { (1..MEDIUM).each { |i| i=0; i+= 1 until i >= MICRO }}
  x.report("until (start):")  { (1..MEDIUM).each { |i| i=0; until i > MICRO do i+=1 end }}

  x.report("upto:")   { (1..MEDIUM).each { |i| 0.upto(MICRO) {} }}
  x.report("times:")  { (1..MEDIUM).each { |i| MICRO.times {} }}
  x.report("each:")   { (1..MEDIUM).each { |i| (0..MICRO).each {} }}
  x.report("for:")    { (1..MEDIUM).each { |i| for i in 0..MICRO do ; end }}

  header("loops - #{SMALL} iterations")
  x.report("while (start):")  { (1..SMALL).each { |i| i=0; while i < MEDIUM do i+=1; end }}
  x.report("while (tail):")  { (1..SMALL).each { |i| i=0; begin i+= 1 end while i <= MEDIUM }}
  x.report("until (tail):")  { (1..SMALL).each { |i| i=0; i+= 1 until i >= MEDIUM }}
  x.report("until (start):")  { (1..SMALL).each { |i| i=0; until i > MEDIUM do i+=1 end }}

  x.report("upto:")   { (1..SMALL).each { |i| 0.upto(MEDIUM) {} }}
  x.report("times:")  { (1..SMALL).each { |i| MEDIUM.times {} }}
  x.report("each:")   { (1..SMALL).each { |i| (0..MEDIUM).each {} }}
  x.report("for:")    { (1..SMALL).each { |i| for i in 0..MEDIUM do ; end }}

  header("loops - #{LARGE} iterations")
  x.report("while (start):")  { (1..MICRO).each { |i| i=0; while i < LARGE do i+=1; end }}
  x.report("while (tail):")  { (1..MICRO).each { |i| i=0; begin i+= 1 end while i <= LARGE }}
  x.report("until (tail):")  { (1..MICRO).each { |i| i=0; i+= 1 until i >= LARGE }}
  x.report("until (start):")  { (1..MICRO).each { |i| i=0; until i > LARGE do i+=1 end }}

  x.report("upto:")   { (1..MICRO).each { |i| 0.upto(LARGE) {} }}
  x.report("times:")  { (1..MICRO).each { |i| LARGE.times {} }}
  x.report("each:")   { (1..MICRO).each { |i| (0..LARGE).each {} }}
  x.report("for:")    { (1..MICRO).each { |i| for i in 0..LARGE do ; end }}

  header("return vs yield")
  x.report("return explicit:")  { (1..LARGE).each { |i| ret(i) }}
  x.report("return implicit:")  { (1..LARGE).each { |i| ret_impl(i) }}
  x.report("yield:")            { (1..LARGE).each { |i| yield_i(i) { } }}

   header("Assignments")
  x.report("c.x=:")   { (1..XLARGE).each { |i| p1.x = 20 } }
  x.report("h.x=:")   { (1..XLARGE).each { |i| p2[:x] = 20 } }
  x.report("s.x=:")   { (1..XLARGE).each { |i| p3.x = 20 } }

  header("Logic")
  x.report("if (1 term):")          { (1..XLARGE).each { |i| true if true }}
  x.report("if-then-end (1 term):") { (1..XLARGE).each { |i| if true then true end }}
  x.report("if-then-else:")         { (1..XLARGE).each { |i| if true then 1 else 0 end }}
  x.report("?:")                    { (1..XLARGE).each { |i| true ? 1 : 0 }}
  x.report("case:")                 { (1..XLARGE).each { |i| case true when true;1 else;0 end }}


  header("Miscellanious")
  x.report("mod:")    { (1..XLARGE).each { |i| i % 2 == 0 } }
  x.report("even:")   { (1..XLARGE).each { |i| i.even? }}

end
