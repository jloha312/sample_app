module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:grademypitch_token] = [user.id, user.salt]
    self.current_user = user
  end
  
  def sign_out
    cookies.delete(:grademypitch_token)
    self.current_user = nil
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_grademypitch_token
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  private
  
    def user_from_grademypitch_token
      User.authenticate_with_salt(*grademypitch_token)
    end
    
    def grademypitch_token
      cookies.signed[:grademypitch_token] || [nil, nil]
    end
end
