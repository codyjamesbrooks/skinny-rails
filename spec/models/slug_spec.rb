require 'rails_helper'
require 'net/http'

RSpec.describe Slug, type: :model do
  subject { build(:slug) }

  it { should validate_presence_of(:url) }
  it { should validate_uniqueness_of(:url) }
  it { should have_many(:lookups) }

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
