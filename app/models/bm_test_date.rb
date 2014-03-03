class BMTestDate < ActiveRecord::Base
  belongs_to :bm_record
  attr_accessible :run_date_time
  validates_uniqueness_of :run_date_time
end
