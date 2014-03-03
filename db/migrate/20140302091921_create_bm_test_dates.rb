class CreateBmTestDates < ActiveRecord::Migration
  def change
    create_table :bm_test_dates do |t|
      #t.belongs_to :bm_record
      t.time :run_date_time
      t.timestamps
    end
  end
end
