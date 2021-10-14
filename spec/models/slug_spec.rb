require 'rails_helper'
require 'net/http'

RSpec.describe Slug, type: :model do
  subject { build(:slug) }

  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:url) }
  it { should validate_uniqueness_of(:url) }
  it { should have_many(:lookups) }


  it "rejects invalid urls" do
    ["this-is-not-a-url",
     "http://garbage",
     "notaformat://notaformat.com",
     1234,
     "user@example.com",
     "!$?"].each_with_index do |url, idx|
      slug = Slug.new(slug: "abcd#{idx}", url: url)
      expect(slug.valid?).to be_falsey
      expect(slug.errors[:url]).not_to be_empty
      expect(slug.errors[:url]).to include("is not a valid url")
    end
  end

  context 'without network validation' do
    before do
      allow(UrlValidator).to receive(:validate_url) { true }
    end

    it "validates the url" do
      url = generate(:uri)
      slug = Slug.create(url: url)
      expect(UrlValidator).to have_received(:validate_url).with(slug.url)
    end

    it { expect(subject).to be_valid }

    it "doesn't orphan lookups when deleted" do
      slug = create(:slug)
      expect {
        slug.lookups.create(attributes_for(:lookup))
      }.to change(Lookup, :count).by(1)

      expect {
        slug.destroy!
      }.to change(Lookup, :count).by(-1)
    end
  end
end
