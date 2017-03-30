require_dependency "binda/application_controller"

module Binda
  class Manage::UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :check_if_is_superadmin, only: [:update, :destroy]

    def index
      @users = User.all
    end

    def show
      redirect_to action: :edit
    end

    def new
      @user = User.new
    end

    def edit
    end

    def create
      @user = User.new( user_params )

      respond_to do |format|
        if @user.save
          format.html { redirect_to manage_user_path( @user.id ), notice: 'User was successfully created.' }
          format.xml  { head :ok }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { redirect_to new_manage_user_path, flash: { alert: @user.errors } }
          format.xml  { head :bad_request }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      if @user.is_superadmin && !current_user.is_superadmin
        redirect_to manage_users_url, notice: 'Sorry, you cannot edit a administrator.'
      else
        respond_to do |format|
          if @user.update(user_params)
            format.html { redirect_to manage_user_path( @user.id ), notice: 'User was successfully updated.' }
            format.xml  { head :ok }
            format.json { render :show, status: :ok, location: @user }
          else
            format.html { redirect_to edit_manage_user_path( @user.id ), flash: { alert: @user.errors } }
            format.xml  { head :bad_request }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    def destroy
      if current_user.email == @user.email
        redirect_to manage_users_url, flash: { alert: 'Sorry, you cannot delete your own account.' }
      elsif !current_user.is_superadmin
        redirect_to manage_users_url, flash: { alert: 'Sorry, you cannot delete an administrator.' }
      else
        @user.destroy
        respond_to do |format|
          format.html { redirect_to manage_users_url, notice: 'User was successfully destroyed.' }
          format.xml  { head :ok }
          format.json { head :no_content }
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def user_params
        params.fetch(:user, {}).permit( :email, :password, :password_confirmation, :is_superadmin )
      end

      # https://github.com/plataformatec/devise/wiki/How-To%3a-Manage-users-through-a-CRUD-interface
      def devise_fix
        if params[:user][:password].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end
      end

      def check_if_is_superadmin
        if current_user.is_superadmin
          redirect_to manage_users_url, alert: 'Sorry, it\'s forbidden to modify this account.'
        end
      end
  end
end