require 'rails_helper'

RSpec.describe "API", type: :request do
  describe "GET /" do
    it "getting the root returns something useful" do
      get '/'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /' do
    context 'with valid params' do
      
      before do
        allow_any_instance_of(Slug::NaiveUrlValidator).to receive(:validate)
      end
  
      let(:slug) { create(:slug) }

      it 'creates a slug' do
        uri = generate(:uri)
        post '/', params: {url: uri}, as: :json
        expect(response).to have_http_status(:created)
        resp = JSON.parse(response.body)
        expect(resp['location']).to include(uri)
      end

      it 'responds with a new location' do
        uri = generate(:uri)
        post '/', params: {url: uri}, as: :json

        expect(response.content_type).to eq('application/json')

        resp = JSON.parse(response.body)
        expect(resp['location']).to eq(uri)
      end

      it 'responds with an existing location' do
        slug = create(:slug)
        post '/', params: {url: slug.url}, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')

        resp = JSON.parse(response.body)
        expect(resp['location']).to eq(slug.url)
      end
    end

    context 'with invalid params' do
      it 'doesnt create jack' do
        expect {
          post '/', params: {url: 'garbage'}, as: :json
        }.not_to change(Slug, :count)
      end

      it 'responds with a boom' do
        post '/', params: {url: 'garbage'}, as: :json

        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET /:slug' do

    before do 
      allow(UrlValidator).to receive(:validate_url) { true }
    end 

    context 'with an existing slug' do
      it 'redirects to :url' do
        slug = create(:slug)
        get "/#{slug.slug}"

        expect(response).to have_http_status(301)
        expect(response).to redirect_to(slug.url)
      end

      it 'creates a lookup' do
        slug = create(:slug)
        expect {
          get "/#{slug.slug}"
        }.to change(Lookup, :count).by(1)
      end
    end

    context 'with an unknown slug' do
      it 'response with file not found' do
        get '/what-the-actual-funk'

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /stats/:slug' do

    before do 
      allow(UrlValidator).to receive(:validate_url) { true }
    end 
    
    context 'for an existing :slug' do
      it 'fetches lookups as JSON' do
        ct = 3
        slug = create(:slug)

        ct.times { get "/#{slug.slug}" }
        get "/stats/#{slug.slug}"

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')

        resp = JSON.parse(response.body)
        expect(resp['lookups']).to eq(ct)
      end
    end

    context 'for a nonexistent :slug' do
      it 'response with file not found' do
        get "/stats/what-the-actual-funk"

        expect(response).to have_http_status(404)
      end
    end
  end
end
