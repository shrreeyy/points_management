class CreateConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :configurations do |t|
      t.float :earn_ratio, default: 0.0
      t.float :burn_ratio, default: 0.0
      t.timestamps
    end
  end
end
