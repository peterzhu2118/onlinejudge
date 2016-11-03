class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.string :email
      t.string :problem_name
      t.integer :runtime
      t.string :result
      t.timestamps
    end
  end
end
