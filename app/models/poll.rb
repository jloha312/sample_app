class Poll < ActiveRecord::Base
  attr_accessible :overall_grade, :personalization, :relevance, :value_proposition, :design, :other, :responder_name, :responder_email, :comments, :next_steps

  belongs_to :user
  
  validates :user_id, :presence => true
  validates :overall_grade, :presence => true
   
  default_scope :order => 'polls.created_at DESC'
  
  scope :strong, where(:overall_grade => 'strong')
  scope :weak, where(:overall_grade => 'weak')
  
  
end
