require 'securerandom'

class Invite < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  
  after_create :create_uuid
  
  protected
    def create_uuid
      self.uuid = SecureRandom.uuid
    end
  
end
