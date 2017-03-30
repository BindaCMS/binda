require_dependency "binda/application_controller"

module Binda
  class SettingsController < ApplicationController
    before_action :set_setting, only: [:show, :edit, :update, :destroy]

    def index
      @settings = Setting.all
    end

    def show
      redirect_to action: :edit
    end

    def new
      @setting = Setting.new
    end

    def edit
    end

    def create
      @setting = Setting.new(setting_params)

      if @setting.save
        redirect_to setting_path( @setting.slug ), notice: 'Setting was successfully created.'
      else
        render :new
      end
    end

    def update
      if @setting.update(setting_params)
        redirect_to setting_path( @setting.slug ), notice: 'Setting was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @setting.destroy
      redirect_to settings_url, notice: 'Setting was successfully destroyed.'
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

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_setting
        @setting = Setting.friendly.find(params[:id])
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
