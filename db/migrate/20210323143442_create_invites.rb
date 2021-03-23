class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites do |t|
      t.belongs_to :user, null: false
      t.belongs_to :todo_list, null: false
      t.string :invite_token, null: false
      t.boolean :confirm, default: false
      t.timestamps
    end

    add_index :invites, :invite_token, unique: true
  end
end
