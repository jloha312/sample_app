require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'index'" do
    
    describe "as a non-admin user" do
      
      before(:each) do
        @user = Factory(:user)
      end
        
      it "should protect the page" do
        test_sign_in(@user)
        get :index, :id => @user
        response.should redirect_to(root_path)
      end
    end
    
    describe "for admin users" do
      
      before(:each) do      
        
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => "Bob", :username => "bob", :email => "another@example.com")
        third  = Factory(:user, :name => "Ben", :username => "ben", :email => "another@example.net")
        
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
        end
        
        admin = Factory(:user, :username => "adminexample", :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end
      
      
      it "should be successful" do
        get :index, :id => @user
        response.should be_success
      end
      
      it "should have the right title" do
        get :index, :id => @user
        response.should have_selector("title", :content => "All users")
      end
      
      it "should have an element for each user" do
        get :index, :id => @user
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end
      
      it "should paginate users" do
        get :index, :id => @user
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
      end
    end
  end

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end
    
    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h2", :content => @user.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h2>img", :class => "gravatar")
    end
    
    it "should show the user's poll results" do
      poll1 = Factory( :poll,
                       :user => @user,
                       :overall_grade      =>  "strong",
                       :personalization    =>  "strong",
                       :relevance          =>  "strong",
                       :value_proposition  =>  "strong",
                       :design             =>  "strong",
                       :other              =>  "good timing",
                       :responder_name     =>  "Tester1",
                       :responder_email    =>  "tester1@gmail.com",
                       :comments           =>  "Really like it - let's talk!",
                       :next_steps         =>  "Setup a Call"
                    )
                    
      poll2 = Factory( :poll,
                       :user => @user,
                       :overall_grade      =>  "weak",
                       :personalization    =>  "weak",
                       :relevance          =>  "weak",
                       :value_proposition  =>  "weak",
                       :design             =>  "weak",
                       :other              =>  "bad timing",
                       :responder_name     =>  "Tester2",
                       :responder_email    =>  "tester2@gmail.com",
                       :comments           =>  "Just aweful!",
                       :next_steps         =>  "none"
                    )
                    
        get :show, :id => @user
        response.should have_selector("img", :class => "pricing_yes")
        response.should have_selector("img", :class => "pricing_no")
        response.should have_selector("span.content", :content => poll1.comments)
        response.should have_selector("span.content", :content => poll2.comments)
    end
  end


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
    
    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    
    it "should have a username field" do
      get :new
      response.should have_selector("input[name='user[username]'][type='text']")
    end
    
    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    
    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    
    it "should have a password confirmation field" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :username => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :name => "New User", :username => "newuser", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /signup success welcome to grademypitch/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
    
    describe "GET 'edit" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end
      
      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edit user")
      end
      
      it "should have a link to change the Gravatar" do
        get :edit, :id => @user
        gravatar_url = "http://gravatar.com/emails"
        response.should have_selector("a", :href => gravatar_url,
                                           :content => "change")
      end
    end
    
    describe "PUT 'update'" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      describe "failure" do
        
        before(:each) do
          @attr = { :name => "", :username => "", :email => "", :password => "",
                    :password_confirmation => "" }
        end
      
        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end
      
        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edit user")
        end
      end
        
      describe "success" do
        
        before(:each) do
          @attr = { :name => "New Name", :username => "newname", :permalink => "newname", :email => "user@example.org",
                    :password => "barbaz", :password_confirmation => "barbaz" }
        end
        
        it "should change the user's attributes" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.name.should == @attr[:name]
          @user.username.should == @attr[:username]
          @user.permalink.should == @attr[:permalink]
          @user.email.should == @attr[:email]
        end
        
        it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end
        
        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/
        end
      end
    end
  end
  
  describe "authentication of edit/update pages" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed-in users" do
      
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        wrong_user = Factory(:user, :username => "userexamplenet", :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      
      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe "DELETE 'destroy" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an admin user" do
      
      before(:each) do
        admin = Factory(:user, :username => "adminexamplecom", :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end
end
