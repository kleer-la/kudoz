require 'securerandom'

class Invite < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  
  validates :message, :guest_email, :presence => true
  
  validates_format_of :guest_email, :with => /.+@.+\..+/i
  
  before_create :create_uuid
  
  protected
    def create_uuid
      self.uuid = SecureRandom.uuid
    end
  
end
