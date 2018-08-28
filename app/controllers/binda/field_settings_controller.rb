require_dependency "binda/application_controller"

module Binda
  class FieldSettingsController < ApplicationController
    before_action :set_structure
    before_action :set_field_group
    before_action :set_field_setting, only: [:show, :edit, :update, :destroy]

    def index
      @field_settings = @field_group.field_settings.order('position').all
    end

    def show
      redirect_to action: :edit
    end

    def new
      @field_setting = @field_group.field_settings.build()
    end

    def edit
    end

    def create
      @field_setting = @field_group.field_settings.build(field_setting_params)

      if @field_setting.save
        redirect_to structure_field_group_field_setting_path( @structure, @field_group, @field_setting ), notice: 'Field setting was successfully created.'
      else
        redirect_to new_structure_field_group_field_setting_path( @structure, @field_group ), flash: { alert: @field_setting.errors }
      end
    end

    def update
      if @field_setting.update(field_setting_params)
        redirect_to structure_field_group_field_setting_path( @structure, @field_group, @field_setting ), notice: 'Field setting was successfully updated.'
      else
        redirect_to edit_structure_field_group_field_setting_path( @structure, @field_group, @field_setting ), flash: { alert: @field_setting.errors }
      end
    end

    def destroy
      @field_setting.destroy!
      FieldSetting.reset_field_settings_array
      if params[:isAjax]
        render json: { target_id: params[:target_id] }, status: 200
      else
        redirect_to structure_field_group_path( @structure, @field_group ), notice: 'Field setting and all dependent content were successfully destroyed.'
      end
    end

    def sort
      params[:field_setting].each_with_index do |id, i|
        FieldSetting.find( id ).update_column('position', i+1) # use update_column to skip callbacks (which leads to huge useless memory consumption)
      end
      render json: { id: "##{params[:id]}" }, status: 200
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find( params[:structure_id] )
      end

      def set_field_group
        @field_group = FieldGroup.friendly.find( params[:field_group_id] )
      end

      def set_field_setting
        @field_setting = FieldSetting.friendly.find( params[:id] )
      end

      # Only allow a trusted parameter "white list" through.
      def field_setting_params
        params.require(:field_setting).permit(:name, :slug, :description, :position, :preview, :required, :default_text, :field_group_id, :field_type )
      end
  end
end
