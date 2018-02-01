require_dependency "binda/application_controller"

module Binda
	class ChoicesController < ApplicationController

		before_action :set_choice

		def destroy
			if @choice.destroy
				head :ok
			else
				render json: { errors: @choice.errors.full_messages }, status: 500
			end
		end

		private

			def set_choice
				@choice = Choice.find( params[:id] )
			end
	end
end