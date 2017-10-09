require_dependency "binda/application_controller"

module Binda
  class ComponentsController < ApplicationController

    before_action :set_structure
    before_action :set_component, only: [:show, :edit, :update, :destroy, :new_repeater, :upload]

    include FieldableHelpers

    def index
      @components = @structure.components.order('position').all.page params[:page]
    end

    def show
      redirect_to action: :edit
    end

    def new
      @component = @structure.components.build()
      # The following variable will be used as wildcard by fieldable views
      @instance = @component
    end

    def edit
    end

    def create
      @component = @structure.components.build(component_params)

      if @component.save
        redirect_to structure_component_path( @structure.slug, @component.slug ), notice: "#{ @structure.name } was successfully created."
      else
        redirect_to new_structure_component_path( @structure.slug ), flash: { alert: @component.errors }
      end
    end

    def update
      if @component.update(component_params)
        redirect_to structure_component_path( @structure.slug, @component.slug ), notice: "#{ @structure.name.capitalize } was successfully updated."
      else
        redirect_to edit_structure_component_path( @structure.slug, @component.slug ), flash: { alert: @component.errors }
      end
    end

    def destroy
      @component.destroy
      redirect_to structure_components_url( @structure.slug ), notice: "#{ @structure.name.capitalize } was successfully destroyed."
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
    
    def sort
      params[:component].each_with_index do |id, i|
        position = params[:component].length * params['page'].to_i + i + 1
        Component.find( id ).update({ position: position })
      end
      head :ok
    end

    def upload
      if @component.update( upload_params(:component) )
        respond_to do |format|
          format.json { render json: upload_details }
        end
      else
        logger.debug("The upload process has failed. #{ @component.errors }")
        head :bad_request 
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find( params[:structure_id] )
      end

      def set_component
        id ||= params[:id]
        id ||= params[:component_id] 
        @component = Component.friendly.find(id)
        # The following variable will be used as wildcard by fieldable views
        @instance = @component
      end

      # Only allow a trusted parameter "white list" through.
      def component_params
        params.require(:component).permit( 
          :name, :slug, :position, :publish_state, :structure_id, :category_ids,
          {structure_attributes:  [ :id ]}, 
          {categories_attributes: [ :id, :category_id ]}, *fieldable_params )
      end

  end
end

