class BMTestName < ActiveRecord::Base
  belongs_to :bm_record
  attr_accessible :test_name
  validates_uniqueness_of :test_name
end


