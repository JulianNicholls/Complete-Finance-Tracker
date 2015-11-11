class User::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:first_namne, :last_name)
    devise_parameter_sanitizer.for(:account_update).push(:first_namne, :last_name)
  end
end
