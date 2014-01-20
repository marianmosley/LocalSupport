class ApplicationController < ActionController::Base
  protect_from_forgery
  def after_sign_in_path_for (resource)
     return root_url if current_user.admin? || current_user.organization == nil
     organization_path(current_user.organization.id)
  end
  def store_location
 # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end
  def allow_cookie_policy
    response.set_cookie 'cookie_policy_accepted', {
        value: 'true',
        path: '/',
        expires: 1.year.from_now.utc
    }
    #respond_to do |format|
    #  format.html redirect_to root_path
    #  format.json { render :nothing => true, :status => 200 }
    #end

    redirect_to root_path
  end
end
