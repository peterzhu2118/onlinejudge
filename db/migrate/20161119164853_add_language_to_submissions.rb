class AddLanguageToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :language, :string
  end
end
