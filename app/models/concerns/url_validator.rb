class UrlValidator < ActiveModel::Validator
  class << self
    def validate_url(url)
      url = URI.parse(url)
      HTTParty.head(url)
      return true
    rescue
    end   
  end
end