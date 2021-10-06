class AddColumnsToLookup < ActiveRecord::Migration[5.0]
  def change
    add_column :lookups, :slug_id, :integer
    add_column :lookups, :ip_address, :string
    add_column :lookups, :referrer, :string
  end
end
