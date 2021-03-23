class AddUserToTodoLists < ActiveRecord::Migration[6.1]
  def change
    add_reference :todo_lists, :user, index: true, foreign_key: true, null: false
  end
end
