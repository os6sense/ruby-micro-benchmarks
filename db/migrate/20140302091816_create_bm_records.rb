class CreateBmRecords < ActiveRecord::Migration
  def change
    create_table :bm_records do |t|
      t.integer :ruby_version_id
      t.integer :test_date_id
      t.integer :test_name_id
      t.float :user
      t.float :system
      t.float :total
      t.float :real
      t.timestamps
    end
  end
end
