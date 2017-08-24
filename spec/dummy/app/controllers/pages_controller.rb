class PagesController < ApplicationController

  def index
  	@pages = get_components('page', { published: false })
  end

  def show
  	@page = Binda::Component.find(params[:id])
  end
  
end
