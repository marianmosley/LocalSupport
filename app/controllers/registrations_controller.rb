class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def create
    if params[:user]
      session[:proposed_org] = params[:user][:proposed_org]
      session[:pending_organisation_id] = params[:user][:pending_organisation_id]
    end

    # copy-pasted from devise's app/controllers/devise/registrations_controller.rb
    # and then modified to return json

    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        flash[:notice] << " You have requested admin status for"
        sign_up(resource_name, resource)
        render json: {url: after_sign_up_path_for(resource)}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        render json: {url: after_inactive_sign_up_path_for(resource)}
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end
  end

  def update_message_for_admin_status
    org = Organisation.find(params[:user][:pending_organisation_id])
    flash[:notice] << " You have requested admin status for #{org.name}"
    send_email_to_superadmin_about_request_for_admin_of org
  end

  protected
    def after_inactive_sign_up_path_for(resource)
      if session[:pending_organisation_id]
        UserOrganisationClaimer.new(self, resource, resource).call(session[:pending_organisation_id])
        return organisation_path resource.pending_organisation_id 
      elsif session[:proposed_org]
        session[:user_id] =  resource.id
        return new_proposed_organisation_path
      else
        send_email_to_superadmin_about_signup resource.email
      end
      root_path
    end

    def send_email_to_superadmin_about_request_for_admin_of org
      superadmin_emails = User.superadmins.pluck(:email)
      AdminMailer.new_user_waiting_for_approval(org.name, superadmin_emails).deliver_now
    end

    def send_email_to_superadmin_about_signup user_email
      superadmin_emails = User.superadmins.pluck(:email)
      AdminMailer.new_user_sign_up(user_email, superadmin_emails).deliver_now
    end

end
