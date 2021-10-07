class RemoveSlugAndUrlFromSlugs < ActiveRecord::Migration[5.0]
  def change
    remove_column :slugs, :slug, :string
    remove_column :slugs, :url, :string
  end
end
