class CreateContests < ActiveRecord::Migration[5.0]
  def change
    create_table :contests do |t|
      t.datetime :begin_time
      t.datetime :end_time
      t.string :title
      t.timestamps
    end
  end
end
