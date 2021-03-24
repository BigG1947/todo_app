class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :text, null: false
      t.belongs_to :user, null: false
      t.belongs_to :todo_list, null: false

      t.timestamps
    end

  end
end
