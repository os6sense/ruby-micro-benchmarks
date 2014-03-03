
class BMRubyVersion < ActiveRecord::Base
  belongs_to :bm_record
  attr_accessible :ruby_version
  validates_uniqueness_of :ruby_version
end

