class HomeController < ApplicationController
  
  def index
    puts 'index called... '
    puts "****** #{session.inspect}"
    @user = current_user
  end
end