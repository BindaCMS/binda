require_dependency "binda/application_controller"

module Binda
  class PagesController < ApplicationController
    before_action :set_structure
    before_action :set_page, only: [:show, :edit, :update, :destroy]

    def index
      @pages = @structure.pages.order('position').all
    end

    def show
      redirect_to action: :edit
    end

    def new
      @page = @structure.pages.build()
    end

    def edit
    end

    def create
      @page = @structure.pages.build(page_params)

      if @page.save
        redirect_to structure_page_path( @structure.slug, @page.slug ), notice: 'Page was successfully created.'
      else
        redirect_to new_structure_page_path( @structure.slug ), flash: { alert: @page.errors }
      end
    end

    def update
      # Create new fields if any
      # new_params[:new_assets].each do |asset|
      #   unless asset[:image].blank?
      #     new_asset = @page.assets.create( asset )
      #     unless new_asset  
      #       return redirect_to edit_structure_page_path( @structure.slug, @page.slug ), flash: { error: new_asset.errors }
      #     end
      #   end
      # end
      if @page.update(page_params)
        redirect_to structure_page_path( @structure.slug, @page.slug ), notice: 'Page was successfully updated.'
      else
        redirect_to edit_structure_page_path( @structure.slug, @page.slug ), flash: { alert: @page.errors }
      end
    end

    def destroy
      @page.destroy
      redirect_to structure_pages_url( @structure.slug ), notice: 'Page was successfully destroyed.'
    end


    # def sort
    #   params[:admin_page].each_with_index do |id, i|
    #     Admin::Page.find( id ).update({ position: i + 1 })
    #   end
    #   head :ok
    # end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find( params[:structure_id] )
      end

      def set_page
        @page = Page.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def page_params
        params.require(:page).permit( 
          :name, 
          :slug, 
          :position, 
          :publish_state, 
          :structure_id, 
          :category_ids,
          structure_attributes: [ 
            :id
            ], 
          categories_attributes: [ 
            :id,
            :category_id 
            ], 
          texts_attributes: [ 
            :id, 
            :field_setting_id, 
            :content
            ], 
          assets_attributes: [ 
            :id,
            :field_setting_id,
            :image
            ], 
          dates_attributes: [ 
            :id,
            :field_setting_id,
            :date
            ], 
          galleries_attributes: [ 
            :id,
            :field_setting_id
            ], 
          repeaters_attributes: [ 
            :id, 
            :field_setting_id, 
            :field_group_id 
            ])
      end

      # def new_params
      #   params.require(:page).permit( new_assets:[ :id, :field_setting_id, :image, :fieldable_id ] )
      # end
  end
end

