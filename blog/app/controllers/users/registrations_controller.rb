# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super do |resource|
      @organizations = Organization.all
    end
  end

  # POST /resource
  def create
    @user = User.new(signup_params)
      # @user = @org.users.build()
    @org = Organization.find(params[:organization_id])
    # debugger

    if @org
      User.transaction do
        if @user.save
          @membership = Membership.new(user_id: @user.id, organization_id: @org.id)
          if @membership.save
            redirect_to root_path, notice: "Thankyou for signing up!! You're now the member of this organization."
          else
            redirect_to new_user_registration_path, notice: "Sorry!! Membership cannot be created"
          end
        else
          redirect_to new_user_registration_path, notice: "Sorry!! Unable to register user"
        end
      end
    else
      redirect_to new_user_registration_path, notice: "Sorry!! Organization was not found."
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  private
  def signup_params
    params.require(:user).permit(:email, :password, :password_confirmation) 
  end
end
