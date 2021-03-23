class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: true
      t.datetime :deadline, null: false

      t.timestamps
    end

    add_reference :tasks, :priority, index: true, foreign_key: true
    add_reference :tasks, :todo_list, index: true, foreign_key: true
  end
end
