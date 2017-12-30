# reference https://stackoverflow.com/a/30668456/1498118
require 'rails_helper'
module Binda
	RSpec.describe ApplicationController, type: :controller do
	  controller do
	    def index; end
	  end

	  describe 'GET index' do
	    it 'will work' do
	      get :index
	    end
	  end

	  describe 'B.get_components()' do
	    before(:context) do
	      @structure = create(:article_structure_with_components_and_fields)
	    end
	  	it 'raises an error if arguments are not valid' do
				expect { B.get_components( @structure.slug ) }.not_to raise_error
	  	end
	  end

	  describe 'B.get_boards()' do
	    before(:context) do
	      @structure = create(:board_structure)
	    end
	  	it 'raises an error if arguments are not valid' do
				expect { B.get_boards( @structure.slug ) }.not_to raise_error
	  	end
	  end
	end
end