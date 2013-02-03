require 'spec_helper'

describe FbLoginsController do
  describe '#create' do 
    it 'redirects to fb authorization url' do
      post :create
      response.should be_redirect
      # response.should redirect_to 'https://www.facebook.com/dialog/oauth'
    end
  end
  
  describe '#post_oauth' do
    it 'processes an oauth msg, gets the access token and creates a user' do
      params = {
        :code => 'fake_fb_code'
      }
      r = mock(Object)
      r.should_receive(:parsed_response).and_return("access_token=fake_access_token")
      FbLoginsController::FbClient.should_receive(:get).with('https://graph.facebook.com/oauth/access_token', anything).and_return(r)
      
      r2 = mock(Object)
      r2.should_receive(:parsed_response).and_return({"email" => "fake_email"})
      FbLoginsController::FbClient.should_receive(:get).with('https://graph.facebook.com/me', anything).and_return(r2)
      
      get :post_oauth, params
      User.count.should == 1
      User.first.email.should == 'fake_email'
    end
  end
end