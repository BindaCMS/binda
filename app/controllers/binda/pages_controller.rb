require_dependency "binda/application_controller"

module Binda
  class PagesController < ApplicationController
    before_action :set_page, only: [:show, :edit, :update, :destroy]

    def index
      @pages = Page.order('position').all
    end

    def show
      redirect_to action: :edit
    end

    def new
      @page = Page.new
    end

    def edit
    end

    def create
      @page = Page.new(page_params)

      if @page.save
        redirect_to page_path( @page.slug ), notice: 'Page was successfully created.'
      else
        render :new
      end
    end

    def update
      if @page.update(page_params)
        redirect_to page_path( @page.slug ), notice: 'Page was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @page.destroy
      redirect_to pages_url, notice: 'Page was successfully destroyed.'
    end


    # def sort
    #   params[:admin_page].each_with_index do |id, i|
    #     Admin::Page.find( id ).update({ position: i + 1 })
    #   end
    #   head :ok
    # end

  def fields_update
    # options = fields_params
    # options.each do |option, content|
    #   unless Admin::Option.friendly.find( option ).update_attributes( content: content )
    #     redirect_to :back, alert: "Sorry. There has been a problem with #{ option }"
    #   end
    # end
    redirect_to :back, notice: 'Page was successfully updated.'
  end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_page
        @page = Page.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def page_params
        params.require(:page).permit( :name, :slug, :position, :publish_state )
      end

      def multiple_params
         params.require(:fields_params).permit()
      end
  end
end

