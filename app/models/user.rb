# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  username           :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :username, :email, :password, :password_confirmation
  
  username_regex = /\A[\w\-]+\z/i
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,  :presence   => true,
                    :length     => { :maximum => 50 }
                    
  validates :username,  :presence   => true,
                        :length     => { :maximum => 50 },
                        :format     => { :with => username_regex },
                        :uniqueness => { :case_sensitive => false }
                        
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
                       
  before_save :encrypt_password, :create_permalink
  
  #Returns true if the user's password matches the submitted password
  def has_password?(submitted_password)
    #Compare stored to submitted encrypted versions
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    #handles 2 scenarios: invalid email and a successful email, password mismatch implicitly since returns nil at end of method
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def to_param
    permalink
  end
  
  private
    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
    def create_permalink
      self.permalink = username.downcase
    end
end
