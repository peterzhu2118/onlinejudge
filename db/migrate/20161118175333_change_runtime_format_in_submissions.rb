class ChangeRuntimeFormatInSubmissions < ActiveRecord::Migration[5.0]
  def change
    change_column :submissions, :runtime, :decimal
  end
end
