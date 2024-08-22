# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super do |resource|
      @organizations = Organization.all
    end
  end

  # POST /resource/sign_in
  def create
    @org = Organization.find_by(id: params[:organization_id])
    @user = User.find_by(email: params[:user][:email])
    @membership = Membership.find_by(user: @user, organization: @org)
      if @org.nil? || @membership.nil?
       return redirect_to new_user_session_path, notice: "Unable to find Orgnization!!" 
      end

      if @user.nil?
      return redirect_to new_user_session_path, notice: "Unable to find User!!" 
      else
        if @user.valid_password?(params[:user][:password])
          session[:org_id] = @org.id
          sign_in_and_redirect @user, notice: "User Sign In Successfully."
        else
          redirect_to new_user_session_path, notice: "Wrong Password"
        end
      end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
