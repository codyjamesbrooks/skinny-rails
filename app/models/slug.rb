class Slug < ApplicationRecord
  class NaiveUrlValidator < ActiveModel::Validator
    def validate(record)
      record.errors.add(:url, "is not a valid url") unless UrlValidator.validate_url(record.url)
    end
  end

  has_many :lookups, dependent: :destroy
  validates :url, presence: true, uniqueness: true
  validates :slug, presence: true
  before_validation :set_slug
  validates_with NaiveUrlValidator

  def set_slug
    loop do 
      self.slug = SecureRandom.uuid[0, 5]
      break unless Slug.where(slug: slug).exists?
    end 
  end
end
