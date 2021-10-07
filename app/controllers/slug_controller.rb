class SlugController < ApplicationController
  skip_before_action :verify_authenticity_token
  def retrive
  end 

  def create
    render json: { location: request.host }, status: 200
    # if Slug.find_by( url: slug_params[:url])
    #   # url exists in db
    #   respond_with_slug
    #   respond_to do |format|
      
    #   end
    # else
    #   # Create a unique slug
    #   # Save the slug
    #   # JSON response
    # end 
    
    # redirect_to root_path
    # # if @slug.save

    # #   redirect_to root_path, notice: "Sucessfull created Slug"
    # # else
    # #   redirect_to root_path, notice: "Failed to create Slug"
    # # end    
  end
  
  private
  
  def slug_params
    params.require(:slug).permit(:url)
  end

  def create_slug( url )
    url.parameterize[0, 5]
  end


end
