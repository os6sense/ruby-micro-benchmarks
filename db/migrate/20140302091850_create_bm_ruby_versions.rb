class CreateBmRubyVersions < ActiveRecord::Migration
  def change
    create_table :bm_ruby_versions do |t|
      #t.belongs_to :bm_record
      t.string :ruby_version
      t.timestamps
    end
  end
end
