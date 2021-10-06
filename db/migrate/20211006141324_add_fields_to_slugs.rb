class AddFieldsToSlugs < ActiveRecord::Migration[5.0]
  def change
    add_column :slugs, :url, :string
    add_column :slugs, :slug, :string
  end
end
