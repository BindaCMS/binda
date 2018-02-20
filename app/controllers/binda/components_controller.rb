require_dependency "binda/application_controller"

module Binda
  class ComponentsController < ApplicationController

    before_action :set_structure
    before_action :set_component, only: [:show, :edit, :update, :destroy, :new_repeater, :upload]

    include FieldableHelpers

    def index
      # set default value
      order = 'LOWER(name) ASC'
      unless params[:order].nil?
        order_hash = params[:order].permit(:name, :publish_state).to_h 
        order = order_hash.map{|k,v| "LOWER(#{k}) #{v}"}.join(', ') if order_hash.any?
      end
      @components = @structure.components.order(order).all.page params[:page]
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
        redirect_to structure_component_path(@structure.slug, @component.slug), notice: "#{ @structure.name } was successfully created."
      else
        @instance = @component
        render :edit, flash: { alert: @component.errors }
      end
    end

    def update
      if @component.update(component_params)
        redirect_to structure_component_path(@structure.slug, @component.slug), notice: "#{ @structure.name.capitalize } was successfully updated."
      else
        render :edit, flash: { alert: @component.errors }
      end
    end

    def destroy
      @component.destroy
      redirect_to structure_components_url(@structure.slug), notice: "#{ @structure.name.capitalize } was successfully destroyed."
    end

    def new_repeater
      @repeater_setting = FieldSetting.find(params[:repeater_setting_id])
      @repeater = @instance.repeaters.create!(field_setting: @repeater_setting)
      render 'binda/fieldable/_form_item_new_repeater', layout: false
    end

    def sort_repeaters      
      sort_repeaters_by(params["form--list-item"])
      render json: { id: "##{params[:id]}" }, status: 200
    end
    
    def sort
      params[:component].each_with_index do |id, i|
        Component.find(id).update_column('position', i+1) # use update_column to skip callbacks (which leads to huge useless memory consumption)
      end
      render json: { id: "##{params[:id]}" }, status: 200
    end

    def sort_index
      return redirect_to structure_components_path, alert: "There are too many #{@structure.name.pluralize}. It's not possible to sort more than #{Component.sort_limit} #{@structure.name.pluralize}." if @structure.components.length > Component.sort_limit
      @components = @structure.components.order('position').all
    end

    def upload
      if @component.update(upload_params(:component))
        render json: upload_details, status: 200
      else
        render json: @component.errors.full_messages, status: 400
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find(params[:structure_id])
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
          :id, :name, :slug, :position, :publish_state, :structure_id, :category_ids,
          {structure_attributes:  [ :id ]}, 
          {categories_attributes: [ :id, :category_id ]}, *fieldable_params)
      end

      # Sort repeaters following the order with which are listed in the array provided as a argument.
      #
      # @param repeaters [Array] the list of ids of the repeaters
      def sort_repeaters_by(repeaters)
        repeaters.each_with_index do |id, i|
          Repeater.find(id).update_column('position', i)
        end
      end
  end
end

