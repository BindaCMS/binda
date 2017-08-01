require_dependency "binda/application_controller"

module Binda
  class ComponentsController < ApplicationController
    before_action :set_structure
    before_action :set_component, only: [:show, :edit, :update, :destroy, :new_repeater]
    before_action :set_position, only: [:create]

    include FieldableHelper

    def index
      @components = @structure.components.order('position').all
    end

    def show
      redirect_to action: :edit
    end

    def new
      @component = @structure.components.build()
    end

    def edit
    end

    def create
      @component = @structure.components.build(component_params)
      @component.position = @position
      if @component.save
        redirect_to structure_component_path( @structure.slug, @component.slug ), notice: "A #{ @component.name } was successfully created."
      else
        redirect_to new_structure_component_path( @structure.slug ), flash: { alert: @component.errors }
      end
    end

    def update
      if @component.update(component_params)
        redirect_to structure_component_path( @structure.slug, @component.slug ), notice: "A #{ @component.name } was successfully updated."
      else
        redirect_to edit_structure_component_path( @structure.slug, @component.slug ), flash: { alert: @component.errors }
      end
    end

    def destroy
      @component.destroy
      redirect_to structure_components_url( @structure.slug ), notice: "A #{ @component.name } was successfully destroyed."
    end

    def new_repeater
      @repeater_setting = FieldSetting.find( params[:repeater_setting_id] )
      position = @component.repeaters.find_all{|r| r.field_setting_id=@repeater_setting.id }.length + 1
      @repeater = @component.repeaters.create( field_setting: @repeater_setting, position: position )
      render 'binda/components/_form_item_new_repeater', layout: false
    end

    def sort_repeaters
      params[:repeater].each_with_index do |id, i|
        Repeater.find( id ).update({ position: i + 1 })
      end
      head :ok
    end

    def sort
      params[:component].each_with_index do |id, i|
        Component.find( id ).update({ position: i + 1 })
      end
      head :ok
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find( params[:structure_id] )
      end

      def set_component
        if params[:component_id].nil?
          return @component = Component.friendly.find(params[:id])
        else
          return @component = Component.friendly.find(params[:component_id])
        end
      end

      # Only allow a trusted parameter "white list" through.
      def component_params
        default_params = params.require(:component).permit( 
          :name, :slug, :position, :publish_state, :structure_id, :category_ids,
          structure_attributes:  [ :id ], 
          categories_attributes: [ :id, :category_id ])

        # merge component default params with fieldable params
        default_params.reverse_merge!(fieldable_params(:component))
      end

      def set_position
        @position = @structure.components.order(:position).pluck(:position).last.to_i + 1 unless @position.to_i > 0
      end

  end
end

