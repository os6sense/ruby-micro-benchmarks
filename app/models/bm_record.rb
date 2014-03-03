class BMRecord < ActiveRecord::Base 
  has_one :ruby_version
  has_one :test_date
  has_one :test_name

  attr_accessible :id,
                  :user,
                  :system,
                  :total,
                  :real

  def add_tms(label, test_date, ruby_version, tms)
    self.test_name_id ||= (tn = BMTestName.new(test_name: label)).save ? tn.id : BMTestName.find_by_test_name(label).id
    self.test_date_id ||= (td = BMTestDate.new(run_date_time: test_date)).save ? td.id : BMTestDate.where("run_date_time=?", test_date).first.id
    self.ruby_version_id ||= (rv = BMRubyVersion.new(ruby_version: ruby_version)).save ? rv.id : BMRubyVersion.find_by_ruby_version(ruby_version).id
    self.user ||= tms.utime
    self.system ||= tms.stime
    self.total ||= tms.total
    self.real ||= tms.real

    save()
  end

  def compare(versions)

    ResultTable.new(versions).tap do | table |
      BMTestName.find(:all).each do | test |
        ResultRow.new(test.test_name).tap do | row |
          versions.each do | ruby_version |
            BMRecord
              .where(test_name_id: test.id, ruby_version_id: BMRubyVersion.find_by_ruby_version(ruby_version).id)
              .tap { | result | row.add_result(ruby_version, result) }
          end
          table.add_row(row)
        end
      end
    end
  end
end

class ResultTable
  attr_reader :versions,
              :results

  def initialize(versions)
    @versions = versions
    @results = {}
  end

  def add_row(result)
    @results[result.name] = result
  end
end

class ResultRow
  attr_reader :name,
              :results

  def initialize(name)
    @name = name
    @results = {}
  end

  def add_result(ruby_version, result)
    @results[ruby_version] = result
      .inject(0.0) { | sum, r | sum + r.real } / result.size 
  end
end 
