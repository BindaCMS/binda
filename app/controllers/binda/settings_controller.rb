require_dependency "binda/application_controller"

module Binda
  class SettingsController < ApplicationController
    before_action :set_setting, only: [:edit, :update, :destroy, :new_repeater]
    before_action :set_structure, only: [:edit, :update, :destroy, :new_repeater]

    include FieldableHelpers

    def show
      redirect_to action: :edit
    end

    def edit
    end

    def update
      if @setting.update(setting_params)
        redirect_to structure_setting_path( @structure.slug, @setting.slug ), notice: 'Setting was successfully updated.'
      else
        redirect_to edit_structure_setting_path( @structure.slug, @setting.slug ), flash: { alert: @setting.errors }
      end
    end

    def destroy
      @setting.destroy
      redirect_to root_url, notice: 'Setting was successfully destroyed.'
    end

    def dashboard
      @structure = Structure.friendly.find('dashboard')
      @setting = Setting.friendly.find('dashboard')
      # The following variable will be used as wildcard by fieldable views
      @instance = @setting
      render :edit
    end

    def new_repeater
      @repeater_setting = FieldSetting.find( params[:repeater_setting_id] )
      position = @instance.repeaters.find_all{|r| r.field_setting_id=@repeater_setting.id }.length + 1
      @repeater = @instance.repeaters.create( field_setting: @repeater_setting, position: position )
      render 'binda/fieldable/_form_item_new_repeater', layout: false
    end

    def sort_repeaters
      params[:repeater].each_with_index do |id, i|
        Repeater.find( id ).update({ position: i + 1 })
      end
      head :ok
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_setting
        id ||= params[:id]
        id ||= params[:setting_id] 
        @setting = Setting.friendly.find(id)
        # The following variable will be used as wildcard by fieldable views
        @instance = @setting
      end

      def set_structure
        @structure = Structure.friendly.find(params[:structure_id])
      end

      # Only allow a trusted parameter "white list" through.
      def setting_params
        default_params = params.require(:setting).permit( 
          :name, :slug, :position, :structure_id,
          { structure_attributes:  [ :id ] },
          *fieldable_params )
      end
  end
end
