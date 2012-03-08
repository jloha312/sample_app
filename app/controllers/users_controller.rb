class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update] 
  before_filter :admin_user,   :only => [:index, :destroy]
  
  def show
    @user = User.find_by_permalink(params[:id])
    @polls = @user.polls.paginate(:page => params[:page])
    @title = @user.name
    @poll = Poll.new
    
    session[:current_polluser] = @user.id
    @user_to_grade = User.find_by_id(session[:remember_token])
    
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      #Handle a successful save.
      sign_in @user
      render 'getting_started'
    else
      @title = "Sign up"
      @user.password = ""
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    @user = User.find_by_permalink(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def destroy
    User.find_by_permalink(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def getting_started
    @title = "Getting Started"
    @user = current_user
    @polls = @user.polls.paginate(:page => params[:page])
    @poll = Poll.new
  end
  
  private
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find_by_permalink(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
