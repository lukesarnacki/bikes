class CreateCoordinators < ActiveRecord::Migration
  def change
    create_table :coordinators do |t|
      t.string :state
      t.timestamps null: false
    end
  end
end
