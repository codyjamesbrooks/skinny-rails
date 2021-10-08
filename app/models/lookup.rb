class Lookup < ApplicationRecord
  belongs_to :slug
  validates :slug, presence: true
  validates :ip_address, presence: true, format: { with: Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex)}
end
