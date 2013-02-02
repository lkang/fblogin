class FbLoginsController < ApplicationController
  
  class FbClient 
    include HTTParty
  end
  
  def new
    # just show the button! actually dont even need this...
    puts "****** the path is: #{post_oauth_fb_login_path}"
    puts "****** the url is: #{post_oauth_fb_login_url}"
  end
  
  def create
    opt = {
      :client_id => FB_CLIENT_ID,
      :scope => "publish_actions",
      :redirect_uri => post_oauth_fb_login_url,
      :state => "12345"
    }
    url = URI.parse 'https://www.facebook.com/dialog/oauth'
    url.query = URI.encode_www_form opt
    puts url.to_s
    redirect_to  url.to_s
  end
  
  
  def post_oauth
    # receive the oauth code
    puts "****** #{params.inspect}"
    opt = {
      :client_id => FB_CLIENT_ID,
      :client_secret => FB_CLIENT_SECRET,
      :redirect_uri => post_oauth_fb_login_url,
      :code => params[:code]
    }
    url = URI.parse 'https://graph.facebook.com/oauth/access_token'
    rsp = FbClient.get( url.to_s, :query => opt )

    rsp_hash = CGI.parse rsp.parsed_response
    session[:access_token] = rsp_hash
    
    # now get some basic user data
    auth_opt = {
      :query => {
        :access_token => session[:access_token]["access_token"].first,
        :client_id => FB_CLIENT_ID
      }
    }
    puts "****** auth_opt: #{auth_opt.inspect}"
    rsp = FbClient.get( 'https://graph.facebook.com/me', auth_opt )
    puts "****** rsp: #{rsp.inspect}"
    rsp_hash = rsp.parsed_response
    session[:username] = rsp_hash["username"]
    session[:name]     = rsp_hash["name"]
    session[:fb_id]    = rsp_hash["id"]
    redirect_to root_path   
  end
  
  def destroy
    session[:username] = nil
    session[:name] = nil
    session[:fb_id] = nil
    session[:access_token] = nil
    redirect_to root_path
  end
end
