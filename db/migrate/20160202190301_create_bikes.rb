class CreateBikes < ActiveRecord::Migration
  def change
    create_table :bikes do |t|
      t.string :state
      t.references :coordinator

      t.timestamps null: false
    end
  end
end
