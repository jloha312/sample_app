require 'spec_helper'

describe Poll do
  
  before(:each) do
    @user = Factory(:user)
    @attr = { :overall_grade      =>  "strong",
              :personalization    =>  "strong",
              :relevance          =>  "weak",
              :value_proposition  =>  "strong",
              :design             =>  "strong",
              :other              =>  "good timing",
              :responder_name     =>  "Christine Liu",
              :responder_email    =>  "christine.liu@gmail.com",
              :comments           =>  "Really like it - let's talk!",
              :next_steps         =>  "none"
              }
  end
  
  it "should create a new instance given valid attributes" do
    @user.polls.create!(@attr)
  end
  
  describe "user associations" do
    
    before(:each) do
      @poll = @user.polls.create(@attr)
    end
    
    it "should have a user attribute" do
      @poll.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @poll.user_id.should == @user.id
      @poll.user.should == @user
    end
  end
  
  describe "validations" do
    
    it "should require a user id" do
      Poll.new(@attr).should_not be_valid
    end
    
    it "should require an overall grade" do
      @user.polls.build(:overall_grade => " ").should_not be_valid 
    end
  end
end
