class SlugController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    render json: Slug.all, status: 200
  end 

  def retrive
    @slug = Slug.find_by(slug: params[:slug])
    if @slug
      @lookup = @slug.lookups.new({ ip_address: request.remote_ip,
                                    referrer: request.referrer })
        if @lookup.save
          response.set_header("Location:", @slug.url) 
          redirect_to @slug.url, status: 301
        end 
    else 
      render json: { error: "Slug does not exist or Lookup is invalid" }, 
             status: :not_found
    end 
  end 
  
  def create
    @slug = Slug.find_by(url: request.params[:url])
    if @slug
      render json: { location: @slug.url },
                     status: 200
    else
      @slug = Slug.create(url: request.params[:url])
      if @slug.save
        render json: { location: @slug.url },
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
      render json: { created_at: @slug.created_at,
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
