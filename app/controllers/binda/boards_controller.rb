require_dependency "binda/application_controller"

module Binda
  class BoardsController < ApplicationController
    before_action :set_board, only: [:edit, :update, :destroy, :new_repeater, :upload ]
    before_action :set_structure, only: [:edit, :update, :destroy, :new_repeater, :upload ]

    include FieldableHelpers

    def show
      redirect_to action: :edit
    end

    def edit
    end

    def update
      if @board.update(board_params)
        redirect_to structure_board_path( @structure.slug, @board.slug ), notice: 'Setting was successfully updated.'
      else
        render :edit, flash: { alert: @board.errors }
      end
    end

    def destroy
      @board.destroy
      redirect_to root_url, notice: 'Setting was successfully destroyed.'
    end

    def new_repeater
      @repeater_setting = FieldSetting.find( params[:repeater_setting_id] )
      position = @instance.repeaters.find_all{|r| r.field_setting_id = @repeater_setting.id }.length + 1
      @repeater = @instance.repeaters.create( field_setting: @repeater_setting, position: position )
      render 'binda/fieldable/_form_item_new_repeater', layout: false
    end

    def sort_repeaters
      params[:repeater].each_with_index do |id, i|
        Repeater.find( id ).update({ position: i + 1 })
      end
      head :ok
    end

    def dashboard
      @structure = Structure.friendly.find('dashboard')
      @board = Board.friendly.find('dashboard')
      @instance = @board
      render action: :edit
    end

    def upload
      if @board.update( upload_params(:board) )
        respond_to do |format|
          format.json { render json: upload_details }
        end
      else
        logger.debug("The upload process has failed. #{ @board.errors }")
        head :bad_request 
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_board
        id ||= params[:id]
        id ||= params[:board_id] 
        @board = Board.friendly.find(id)
        # The following variable will be used as wildcard by fieldable views
        @instance = @board
      end

      def set_structure
        @structure = Structure.friendly.find(params[:structure_id])
      end

      # Only allow a trusted parameter "white list" through.
      def board_params
        params.require(:board).permit( 
          :name, :slug, :position, :structure_id,
          { structure_attributes:  [ :id ] },
          *fieldable_params )
      end
  end
end
