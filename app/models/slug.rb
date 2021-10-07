class Slug < ApplicationRecord
  validates :url, uniqueness: true, format: URI::regexp(%w[http https])
  before_create :set_slug

  def set_slug
    loop do 
      self.slug = SecureRandom.uuid[0, 5]
      break unless Slug.where(slug: slug).exists?
    end 
  end 
end
