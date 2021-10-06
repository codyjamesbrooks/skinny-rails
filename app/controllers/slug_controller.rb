class SlugController < ApplicationController
  def index
  end 

  def create
    @slug = Slug.new(slug_params)
    if @slug.save
      redirect_to root_path, notice: "Sucessfull created Slug"
    else
      redirect_to root_path, notice: "Failed to create Slug"
    end    
  end
  
  private
  
  def slug_params
    params.require(:slug).permit(:url)
  end
end
