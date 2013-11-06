require 'spec_helper'

describe "users/index.html.erb" do
  let(:org1) do
   mock_model Organization, :id => 5, :name => 'test', :address => "12 pinner rd", :postcode => "HA1 4HP",:telephone => "1234", :website => 'http://a.com', :description => 'I am test organization hahahahahhahaha', :lat => 1, :lng => -1
  end

  let(:user1) do
    stub_model User,:email => 'test@test.org', :pending_organization_id => org1.id
  end

  let(:user2) do
    stub_model User,:email => 'test2@test.org', :pending_organization_id => 5
  end

  let(:users) do
    [user1,user2]
  end

  before(:each) do
    assign(:users, users)
  end

  context "logged in admin user"  do
    before :each do
      assign(:organizations, organizations)
      @user = double('user')
      @user.stub(:id => 100)
      view.stub(:current_user) {@user}
      @user.admin(:try).with(:admin?).and_return(true)
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
