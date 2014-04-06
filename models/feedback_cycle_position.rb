class FeedbackCyclePosition < ActiveRecord::Base
  belongs_to :feedback_cycle
  belongs_to :user
  
end