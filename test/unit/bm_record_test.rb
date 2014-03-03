require 'test_helper'

class BmRecordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "add_tms adds a tms record to the db" do
    TMS = Struct(:user, :system, :total, :real)
    tms = TMS.new(1.0, 2.0, 3.0, 4.0)
    bm = BMRecord.new.add_tms("test", DateTime.now, tms)
  end

end
