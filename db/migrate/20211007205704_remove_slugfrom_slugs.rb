class RemoveSlugfromSlugs < ActiveRecord::Migration[5.0]
  def change
    remove_column :slugs, :slug, :string
  end
end
