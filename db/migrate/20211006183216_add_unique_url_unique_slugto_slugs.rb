class AddUniqueUrlUniqueSlugtoSlugs < ActiveRecord::Migration[5.0]
  def change
    add_column :slugs, :slug, :string
    add_column :slugs, :url, :string
  end
end
