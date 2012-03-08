class PollsController < ApplicationController
  
  def create
    
    user_to_grade = User.find_by_id(session[:current_polluser])
    @poll = user_to_grade.polls.build(params[:poll])
    		    
    if @poll.save
      flash[:success] = "Pitch graded successfully!"
      render 'poll_recap'
    else
      render 'new'
    end
  end

end