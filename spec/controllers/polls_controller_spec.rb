require 'spec_helper'

describe PollsController do
	render_views
	
	describe "POST 'create'" do
	  
	  before(:each) do
	    @user = the test pitch to grade
	  end
	  
	  describe "failure" do
	    
	    before(:each) do
	      @attr = { :overall_grade => "" }
	    end
	    
	    it "should not create a poll" do
	      lambda do
	        post :create, :poll => @attr
	      end.should_not change(Poll, :count)
	    end
	    
	    it "should render the users page" do
	      post :create, :poll => @attr
	      response.should render_template('pages/users')
	    end
	  end
	  
	  describe "success" do
	    
	    before(:each) do
	      @attr = { :overall_grade => "strong"}
	    end
	    
	    it "should create a poll" do
	      lambda do
	        post :create, :poll => @attr
	      end.should change(Poll, :count).by(1)
	    end
	    
	    it "should redirect to the recap page" do
	      post :create, :poll => @attr
	      response.should redirect_to('pages/recap')
	    end
	    
	    it "should have a flash message" do
	      post :create, :poll => @attr
	      flash[:success].should =~ /pitch graded successfully/i
	    end
	  end
	end
end