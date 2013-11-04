require 'spec_helper'
require 'ruby-debug'

describe UsersController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "GET index" do
    context "while signed in as admin" do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
        user.should_receive(:admin?).and_return(true)
      end
      it 'should display all users' do
        User.should_receive(:all)
        get :index, :charity_admin_pending => "false"
      end
      it "renders the users index" do
        get :index, :charity_admin_pending => "true"
        response.should render_template 'index'
      end
    end
    context "while signed in as non-admin" do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
        user.should_receive(:admin?).and_return(false)
      end
      it "sends a message to the flash" do
        get :index, :charity_admin_pending => "true"
        expect(flash[:alert]).to eq("You must be signed in as admin to perform that action!")
      end
      it "redirects to root path" do
        get :index
        expect(response).to redirect_to root_path
      end
    end
    context "while not signed in" do
      it "redirects to sign-in" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PUT #approve_charity_admin" do
    before do
      admin = double("Admin")
      request.env['warden'].stub :authenticate! => admin
      controller.stub(:current_user).and_return(admin)
      admin.should_receive(:admin?).and_return(true)
    end

    # TODO "2 admins approving pending_user" do
    #   it "should not happen" do
    #     pending
    #   end
    # end

    context "there are users with pending_organization_ids" do
      it "should set pending_organization_id (happy path)" do
        pending_user = double("User")
        User.should_receive(:find_by_id).with("3").and_return(pending_user)
        pending_user.stub(:pending_organization_id).and_return(5)
        pending_user.should_receive(:pending_organization_id=).with(nil)
        pending_user.should_receive(:organization_id=).with(5)
        pending_user.should_receive(:save!)
        put :approve_charity_admin, id: "3"
      end
    end
    context "there are no users with pending_organization_ids" do
      it "should not allow admin to approve user (sad path)" do
        pending_user = double("User")
        User.should_receive(:find_by_id).with("3").and_return(pending_user)
        pending_user.stub(:pending_organization_id).and_return(nil)
        pending_user.should_not_receive(:pending_organization_id=).with(5)
        pending_user.should_not_receive(:organization_id=).with(nil)
        put :approve_charity_admin, id: 3
      end
    end
  end

  describe "PUT #reject_charity_admin" do
    before do
      admin = double("Admin")
      request.env['warden'].stub :authenticate! => admin
      controller.stub(:current_user).and_return(admin)
      admin.should_receive(:admin?).and_return(true)
    end
    context "there are users with pending_organization_ids" do
      it "should set pending_organization_id to nil (happy path)" do
        pending_user = double("User")
        User.should_receive(:find_by_id).with("4").and_return(pending_user)
        pending_user.stub(:pending_organization_id).and_return(5)
        pending_user.should_receive(:pending_organization_id=).with(nil)
        pending_user.should_receive(:save!)
        put :reject_charity_admin, id: "4"
      end
    end

    context "there are no users with pending_organization_ids" do
      it "should not allow admin to reject user (sad path)" do
        pending_user = double("User")
        User.should_receive(:find_by_id).with("4").and_return(pending_user)
        pending_user.stub(:pending_organization_id).and_return(nil)
        pending_user.should_not_receive(:pending_organization_id=)
        put :reject_charity_admin, id: "4"
      end
    end
  end
end
