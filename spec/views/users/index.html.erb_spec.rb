require 'spec_helper'

describe "users/index.html.erb" do
  context "logged in admin user"  do
    let(:org1) do
      Gmaps4rails.stub(:geocode)
      FactoryGirl.create(:organization, :id => 5)
    end

    let(:user1) do
      stub_model User,:email => 'test@test.org', :pending_organization_id => org1.id
    end

    let(:user2) do
      stub_model User,:email => 'test2@test.org', :pending_organization_id => nil
    end

    let(:users) do
      [user1,user2]
    end

    before :each do
      assign(:users, users)
      @user = FactoryGirl.create(:user)
      @user.stub(:id => 100)
      view.stub(:current_user) {@user}
      @user.stub(:admin?).and_return(true)
      @user.pending_organization_id = 5
      render
    end
    it "renders Approve and Reject links" do
      rendered.should have_link 'Approve'
      rendered.should have_link 'Reject'
    end
    it "does render a list of users for logged in admin user"  do
      rendered.should have_xpath("//a[@href='#{users_path}']")
    end
  end

end
