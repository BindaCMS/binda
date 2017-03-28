require_dependency "binda/application_controller"

module Binda
  class FieldSettingsController < ApplicationController
    before_action :set_field_setting, only: [:show, :edit, :update, :destroy]

    # GET /field_settings
    def index
      @field_settings = FieldSetting.all
    end

    # GET /field_settings/1
    def show
    end

    # GET /field_settings/new
    def new
      @field_setting = FieldSetting.new
    end

    # GET /field_settings/1/edit
    def edit
    end

    # POST /field_settings
    def create
      @field_setting = FieldSetting.new(field_setting_params)

      if @field_setting.save
        redirect_to field_setting_path( @field_setting.slug ), notice: 'Field setting was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /field_settings/1
    def update
      if @field_setting.update(field_setting_params)
        redirect_to field_setting_path( @field_setting.slug ), notice: 'Field setting was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /field_settings/1
    def destroy
      @field_setting.destroy
      redirect_to field_settings_url, notice: 'Field setting was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_field_setting
        @field_setting = FieldSetting.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def field_setting_params
        params.require(:field_setting).permit(:name, :slug, :description, :position, :required, :default_text)
      end
  end
end
