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
        redirect_to structure_field_group_field_setting_path( @structure.slug, @field_group.slug, @field_setting.slug ), notice: 'Field group was successfully created.'
      else
        redirect_to new_structure_field_group_field_setting_path( @structure.slug, @field_group.slug ), flash: { alert: @field_setting.errors }
      end
    end

    def update
      if @field_setting.update(field_setting_params)
        redirect_to structure_field_group_field_setting_path( @structure.slug, @field_group.slug, @field_setting.slug ), notice: 'Field group was successfully updated.'
      else
        redirect_to edit_structure_field_group_field_setting_path( @structure.slug, @field_group.slug, @field_setting.slug ), flash: { alert: @field_setting.errors }
      end
    end

    def destroy
      @field_setting.destroy
      redirect_to structure_field_group_path( @structure.slug, @field_group.slug ), notice: 'Field group was successfully destroyed.'
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
        params.require(:field_setting).permit(:name, :slug, :description, :position, :required, :default_text, :field_group_id, :field_type )
      end
  end
end
