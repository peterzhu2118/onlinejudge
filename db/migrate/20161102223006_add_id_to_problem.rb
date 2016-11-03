class AddIdToProblem < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :contest_id, :integer
  end
end
