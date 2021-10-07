class SlugController < ApplicationController
  skip_before_action :verify_authenticity_token
  def retrive
  end 

  def create
    @slug = Slug.new(url: request_url)

    if @slug.save
      render json: { slug: "#{@slug.slug}", 
                     'lookup_url': create_lookup_url(@slug.slug) },
                     status: 201
    elsif @slug.errors == :taken
      correct_slug = Slug.find_by(url: @slug.url).slug
      render json { 'lookup url': create_lookup_url(correct_slug) },
                    status: 200
    else
      render json { error: @slug.errors.full_messages.first },
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
