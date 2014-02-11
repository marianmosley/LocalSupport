require 'spec_helper'

describe Devise::SessionsController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "POST create" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it 'redirects to home page after admin logs-in' do
      FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp', :admin => true}).save!
      post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
      expect(response).to redirect_to root_url
    end

    it 'renders sign in page after someone fails to log-in with non-existent account' do
      post :create, 'user' => {'email' => 'example@example.com', 'password' => '12345'}
      expect(response).to be_ok
    end

    it 'displays warning flash after someone fails to log-in with non-existent account' do
      post :create, 'user' => {'email' => 'example@example.com', 'password' => '12345'}
      expect(flash[:alert]).to have_content "I'm sorry, you are not authorized to login to the system."
    end

    describe 'non-admins' do
      describe 'associated with an organization LOGS IN' do
        it 'redirects to organization page' do
          Gmaps4rails.stub(:geocode)
          org = FactoryGirl.create(:organization, {:email => 'example@example.com'})
          FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp', :organization => org}).save!
          post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
          expect(response).to redirect_to organization_path(org.id)
        end
      end
      describe 'associated with nothing LOGS IN' do
        it 'redirects to previous page after non-admin associated with nothing logs-in from charity page' do
          request.stub(:path).and_return(organization_path(1))
          #session.stub(:previous_url).and_return(organization_path(1))
          FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp'}).save!
          post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
          expect(response).to redirect_to organization_path(1)
        end

        it 'redirects to root after non-admin associated with nothing logs-in from sign in page' do
          FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp'}).save!
          post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
          expect(response).to redirect_to root_url
        end

        it 'redirects to home page after non-admin associated with nothing logs-in' do
          FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp'}).save!
          post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
          expect(response).to redirect_to root_url
        end
      end
      describe 'associated with nothing FAILS TO LOG IN' do
        it 'renders sign in page after non-admin associated with nothing fails to log-in' do
          FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp'}).save!
          post :create, 'user' => {'email' => 'example@example.com', 'password' => '12345'}
          expect(response).to be_ok
        end

        it 'displays warning flash after non-admin associated with nothing fails to log-in' do
          FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp'}).save!
          post :create, 'user' => {'email' => 'example@example.com', 'password' => '12345'}
          expect(flash[:alert]).to have_content "I'm sorry, you are not authorized to login to the system."
        end
      end
    end


  end
end
