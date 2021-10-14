require 'rails_helper'

RSpec.describe UrlValidator do
  it "responds with nil with url is invalid" do
    ["this-is-not-a-url",
     "http://garbage",
     "notaformat://notaformat.com",
     1234,
     "user@example.com",
     "!$?"].each_with_index do |url, idx|
      
      expect(UrlValidator.validate_url(url)).to be_nil
    end
  end

  it "responds with true with valid urls" do
    ["https://google.com",].each do |url|

      expect(UrlValidator.validate_url(url)).to be true
    end
  end
end
