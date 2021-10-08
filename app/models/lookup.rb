class Lookup < ApplicationRecord
  belongs_to :slug
  validates :slug, presence: true
end
