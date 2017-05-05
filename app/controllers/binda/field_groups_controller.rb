require_dependency "binda/application_controller"

module Binda
  class FieldGroupsController < ApplicationController
    before_action :set_structure
    before_action :set_field_group, only: [:show, :edit, :update, :destroy]

    def index
      @field_groups = @structure.field_groups.order('position').all
    end

    def show
      redirect_to action: :edit
    end

    def new
      @field_group = @structure.field_groups.build(  )
    end

    def edit
    end

    def create
      @field_group = @structure.field_groups.build(field_group_params)

      if @field_group.save
        redirect_to structure_field_group_path( @structure.slug, @field_group.slug ), notice: 'Field group was successfully created.'
      else
        redirect_to new_structure_field_group_path( @structure.slug ), flash: { alert: @field_group.errors }
      end
    end

    def update
      # Create new fields if any
      new_params[:new_field_settings].each do |field_setting|
        unless field_setting[:name].blank?
          new_field_setting = @field_group.field_settings.create( field_setting )
          unless new_field_setting  
            return redirect_to edit_structure_field_group_path( @structure.slug, @field_group.slug ), flash: { error: new_field_setting.errors }
          end
        end
      end

      # Update the other ones
      if @field_group.update(field_group_params)
        redirect_to structure_field_group_path( @structure.slug, @field_group.slug ), notice: 'Field group was successfully updated.'
      else
        redirect_to edit_structure_field_group_path( @structure.slug, @field_group.slug ), flash: { alert: @field_group.errors }
      end
    end

    def destroy
      @field_group.destroy
      redirect_to structure_path( @structure.slug ), notice: 'Field group was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find( params[:structure_id] )
      end

      def set_field_group
        @field_group = FieldGroup.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def field_group_params
        params.require(:field_group).permit(
          :name, 
          :slug, 
          :description, 
          :position, 
          :layout,
          :structure_id,
          field_settings_attributes: [
            :id, 
            :field_group_id,
            :field_setting_id,
            :name, 
            :slug,
            :description,
            :field_type,
            :position,
            :required,
            :default_text,
            :ancestry
          ])
      end

      def new_params
        params.require(:field_group).permit( 
          new_field_settings:[ 
            :field_group_id, 
            :field_setting_id,
            :name, 
            :slug,
            :description, 
            :field_type, 
            :position,
            :required,
            :ancestry
            ])
      end
  end
end
