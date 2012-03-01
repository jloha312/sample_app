class PagesController < ApplicationController
  def home
    @title = "Home"
    @poll = Poll.new
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
    @user = current_user
    @poll = Poll.new
  end
end
