class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems do |t|
      t.string :title
      t.text :problem
      t.integer :runtime
      t.integer :memory
      t.text :input
      t.text :output 
      t.timestamps
    end
  end
end
