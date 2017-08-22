require 'benchmark'

class PagesController < ApplicationController
  def index
  	Benchmark.bmbm do |b|
  		b.report('Binda::Component') { Binda::Component.find_by(slug: 'page') }
  		b.report('get_components')   { get_components('page') }
  	end
  	@pages = Binda::Component.all
  end

  def show
  	@page = Binda::Component.find(params[:id])
  end
end
