class SlugController < ApplicationController  
  def index
    render json: Slug.all, status: 200
  end 

  def retrive
    @slug = Slug.find_by(slug: params[:slug])

    unless @slug
      render json: { error: "Slug does not exist or Lookup is invalid" }, 
      status: :not_found
      return    
    end 

    @slug.lookups.create!({ ip_address: request.remote_ip,
                            referrer: request.referrer })
    response.set_header("Location:", @slug.url) 
    redirect_to @slug.url, status: 301
  end 
  
  def create
    @slug = Slug.find_by(url: request.params[:url])
    if @slug
      render json: { location: @slug.url }, status: 200
      return
    end

    @slug ||= Slug.create(url: request.params[:url])
    if @slug.save
      render json: { location: @slug.url }, status: 201
      return
    end

    render json: { error: "Invalid url submitted" }, status: 400
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
end
