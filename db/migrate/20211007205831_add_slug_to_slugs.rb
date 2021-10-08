class AddSlugToSlugs < ActiveRecord::Migration[5.0]
  def change
    add_column :slugs, :slug, :string, unique: true
  end
end
