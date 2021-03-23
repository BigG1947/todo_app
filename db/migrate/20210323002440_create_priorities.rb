class CreatePriorities < ActiveRecord::Migration[6.1]
  def change
    create_table :priorities do |t|
      t.string :name, null: false
      t.integer :level, null: false

      t.timestamps
    end
    add_index :priorities, %i[name level], unique: true
  end
end
