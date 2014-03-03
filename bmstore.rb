require 'active_record'
require_relative 'app/models/bm_test_name'
require_relative 'app/models/bm_test_date'
require_relative 'app/models/bm_ruby_version'
require_relative 'app/models/bm_record'

class BMStore
  # Attempts to save the record into a database as defined by the rails 
  # database. If is fails it silently fails.
  #
  # id concatination
  # id 1.9.2
  # id datetime - generated at start of tests
  # id test_name_id, ruby: _version_id, test_run_id, user, system, total, real
  def initialize(label, test_date, ruby_version, source_line, tms)
    begin
      BMRecord.new
        .add_tms(label, test_date, ruby_version, source_line, tms)

    rescue ActiveRecord::ConnectionNotEstablished
    end
  end
end


class SourceLine
  def initialize(line)
    # benchmarks.rb:122:in `containers_aa'
    @filename = line[0..(i=line.index(':'))-1]
    @line_no =  line[i+1..(line.index(':', i+1)-1 )]
    @method_name = line[line.index('`')+1..-2]
    #@code = 
    
    puts @line
    puts @filename 
    puts @line_no
    puts @method_name
  end

  def get_line(filename, line_number)
    File.open(filename, 'r')
  end

end
    
