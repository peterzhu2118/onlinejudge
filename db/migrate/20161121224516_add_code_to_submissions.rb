class AddCodeToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :code, :text
  end
end
