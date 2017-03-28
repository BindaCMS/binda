class PagesController < ApplicationController
  def index
  	@pages = Binda::Page.all
  end

  def show
  	@page = Binda::Page.find(params[:id])
  end
end
