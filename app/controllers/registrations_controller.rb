# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  protected

  # Allow updates without current password unless password is being changed
  def update_resource(resource, params)
    if params[:password].present? || params[:password_confirmation].present?
      super # Devise default: requires current_password
    else
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
