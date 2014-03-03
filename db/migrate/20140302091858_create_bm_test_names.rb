class CreateBmTestNames < ActiveRecord::Migration
  def change
    create_table :bm_test_names do |t|
      #t.belongs_to :bm_record
      t.string :test_name
      t.timestamps
    end
  end

  def up
  end

  def down
  end

end
