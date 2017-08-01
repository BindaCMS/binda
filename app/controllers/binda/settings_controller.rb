require_dependency "binda/application_controller"

module Binda
  class SettingsController < ApplicationController
    before_action :set_setting, only: [:show, :edit, :update, :destroy, :new_repeater]
    before_action :set_structure

    include FieldableHelper

    def index
      # TODO this is a temporary workaround
      redirect_to action: :edit
    end

    def show
      redirect_to action: :edit
    end

    def new
      @setting = @structure.setting.build()
    end

    def edit
    end

    def create
      @setting = @structure.setting.build(setting_params)

      if @setting.save
        redirect_to setting_path( @structure.slug, @setting.slug ), notice: 'Setting was successfully created.'
      else
        redirect_to new_structure_setting_path( @structure.slug ), flash: { alert: @setting.errors }
      end
    end

    def update
      if @setting.update(setting_params)
        redirect_to setting_path( @structure.slug, @setting.slug ), notice: 'Setting was successfully updated.'
      else
        redirect_to edit_structure_setting_path( @structure.slug, @setting.slug ), flash: { alert: @setting.errors }
      end
    end

    def destroy
      @setting.destroy
      redirect_to root_url, notice: 'Setting was successfully destroyed.'
    end

    def dashboard
      @settings  = Setting.all
      @dashboard = Setting
    end

    def update_dashboard
      dashboard_params[:settings].each do |id|
        setting = Setting.find(id)
        unless setting.update( dashboard_params[:settings][id.to_s] )
          return redirect_to dashboard_path, flash: { error: setting.errors }
        end
      end
      redirect_to dashboard_path, flash: { notice: 'Dashboard was successfully updated.' } 
    end

    def sort
      params[:component].each_with_index do |id, i|
        Component.find( id ).update({ position: i + 1 })
      end
      head :ok
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_setting
        @setting = Setting.friendly.find(params[:id])
      end

      def set_structure
        @structure = Structure.friendly.find( params[:structure_id] )
      end

      def dashboard_params
        params.require(:dashboard).permit( settings: [ :id, :name, :content, :slug, :position, :is_true ] )
      end

      # Only allow a trusted parameter "white list" through.
      def setting_params
        params.require(:setting).permit(:name, :content, :slug, :position, :dashboard )
      end
  end
end
