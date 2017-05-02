class PagesController < ApplicationController
  def index
  	@pages = Binda::Component.all
  end

  def show
  	@page = Binda::Component.find(params[:id])
  end
end
