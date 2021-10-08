class SlugController < ApplicationController
  skip_before_action :verify_authenticity_token
  def retrive
    @slug = Slug.find_by(slug: params[:slug])
    if @slug
      # Create Lookup, send full url in response header
      @slug.lookups.create({
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
    url = request_url
    @slug = Slug.find_by(url: url)
    if @slug
      render json: { location: "#{request.domain}/#{@slug.slug}" },
                     status: 200
    else
      @slug = Slug.create(url: url)
      if @slug.save
        render json: { location: "#{request.domain}/#{@slug.slug}" },
                        status: 200
      else
        render json: { error: "Invalid url submitted" },
                       status: 400
      end 
    end 
  end 
  
  def stats
    @slug = Slug.find_by(slug: params[:slug])
    
    if @slug
      render json: { created_at: @slug.created_at
                     lookups: @slug.lookups.count },
                     status: 200
    else
      render json: { error: "Slug does not exist" },
             status: 404
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
