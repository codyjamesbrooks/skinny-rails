class Lookup < ApplicationRecord
  class NaiveLookupValidator < ActiveModel::Validator
    def validate( record )
      unless UrlValidator.validate_url(record.referrer)
        record.errors.add(:referrer, "is not a valid url")
      end 
    end 
  end  
  
  belongs_to :slug
  validates :slug, presence: true
  validates :ip_address, presence: true, format: { with: Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex), message: "is not a valid ip address"}
  validates_with NaiveLookupValidator
end