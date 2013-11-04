class UsersController < ApplicationController

  # before_filter do 
  #   redirect_to root_url, alert: "You must be signed in as admin to perform that action!" unless current_user && current_user.admin?
  # end

  def index
    if current_user.blank?
      redirect_to user_session_path, alert: "You must be signed in as admin to perform that action!"
    elsif current_user.admin?
      if params[:charity_admin_pending] == "true"
        @users = User.where("users.pending_organization_id IS NOT NULL")
      else
        @users = User.all
      end
    else
      redirect_to root_url, alert: "You must be signed in as admin to perform that action!"
    end
  end

  def approve_charity_admin
    redirect_to root_url unless current_user.admin?
    pending_user = User.find_by_id(params[:id])
    org_id = pending_user.pending_organization_id
    unless org_id.blank?
      pending_user.pending_organization_id = nil
      pending_user.organization_id = org_id
      pending_user.save!
    end
    redirect_to users_path 
  end

  def reject_charity_admin
    redirect_to root_url unless current_user.admin?
    pending_user = User.find_by_id(params[:id])
    if pending_user.pending_organization_id
      pending_user.pending_organization_id = nil
      pending_user.save!
    end
    redirect_to users_path
  end

end
