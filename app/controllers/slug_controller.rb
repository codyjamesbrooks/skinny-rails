class SlugController < ApplicationController
  skip_before_action :verify_authenticity_token
  def retrive
    @slug = Slug.find_by(slug: params[:slug])
    if @slug
      # Create Lookup, send full url in response header
      Lookup.create({
        slug_id: @slug.id,
        ip_address: request.remote_ip,
        referrer: request.referrer
      })
      response.set_header("Location:", @slug.url) 
      redirect_to @slug.url, status: 301
    else 
      render json: { error: "Slug does not exist" }, 
             status: :not_found
    end 
  end 

  def create
    @slug = Slug.new(url: request_url)

    if @slug.save
      payload = 
      render json: { location: "#{request.domain}/#{@slug.slug}" },
                     status: 201
    end 

    if @slug.errors == :taken
      correct_slug = Slug.find_by(url: @slug.url).slug
      render json: { lookup_url: "#{request.domain}/#{correct_slug}" }.to_json,
                    status: 200
    else
      render json: { error: @slug.errors.full_messages.first },
                    status: 400
    end
  end
  
  private
  
  def request_url
    request.body.read.sub(/url=/, "")
  end

  def create_lookup_url( slug ) 
    "#{request.host}/#{slug}"
  end 

end
