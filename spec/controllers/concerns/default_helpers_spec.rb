# reference https://stackoverflow.com/a/30668456/1498118
require 'rails_helper'
module Binda
	RSpec.describe ApplicationController, type: :controller do
	  controller do
	    include DefaultHelpers

	    def index; end
	  end

	  describe 'GET index' do
	    it 'will work' do
	      get :index
	    end
	  end

	  describe 'get_components()' do
	    before(:context) do
	      @structure = create(:article_structure_with_components_and_fields)
	    end
	  	it 'raises an error if arguments are not valid' do
				expect { controller.get_components( @structure.slug ) }.not_to raise_error
				expect { controller.get_components( @structure.slug, { xxx: {} }) }.to raise_error ArgumentError
				expect { controller.get_components( @structure.slug, { fields: {} }) }.to raise_error ArgumentError
				expect { controller.get_components( @structure.slug, { fields: 'strings' }) }.to raise_error ArgumentError
				expect { controller.get_components( @structure.slug, { fields: [:strings] }) }.not_to raise_error
				expect { controller.get_components( @structure.slug, { fields: ['strings'] }) }.not_to raise_error
				expect { controller.get_components( @structure.slug, { custom_order: :position }) }.to raise_error ArgumentError
				expect { controller.get_components( @structure.slug, { custom_order: 'position' }) }.not_to raise_error
				expect { controller.get_components( @structure.slug, { published: false, custom_order: 'xxx' }).length }.to raise_error ActiveRecord::StatementInvalid
	  	end
	  end
	end
end