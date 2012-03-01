class PollsController < ApplicationController
  
  def create
    if current_user.blank?
      user_to_grade = User.find_by_id(session[:remember_token])
      @poll = user_to_grade.polls.build(params[:poll])
    else
      @poll = current_user.polls.build(params[:poll])
    end    
    
    if @poll.save
      flash[:success] = "Pitch graded successfully!"
      redirect_to root_path
    else
      render 'pages/home'
    end
  end

end