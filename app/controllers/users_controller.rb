class UsersController < ApplicationController
  layout 'full_width'
  before_filter :authorize, :except => [:update]

  # would like this to support generic updating of model with
  # business logic pulled into a separate model or process
  def update
    user = User.find_by_id(params[:id])
    debugger
    if params[:organization_id]
      attribs = { pending_organization_id: params[:organization_id] }
      org = Organization.find(params[:organization_id])
      msg = "You have requested admin status for #{org.name}"
      path = organization_path(params[:organization_id])
    else
      return unless authorize
      attribs = { organization_id: user.pending_organization_id, pending_organization_id: nil }
      msg = "You have approved #{user.email}."
      path = users_path
    end
    user.update_attributes!(attribs)
    flash[:notice] = msg
    redirect_to(path)
  end

  def index
    @users = User.all
  end
end
