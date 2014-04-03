require 'securerandom'

class Invite < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  
  validates :message, :guest_email, :presence => true
  validates_format_of :guest_email, :with => /.+@.+\..+/i
  
  after_initialize :set_default_values, if: :new_record?

  protected

  def set_default_values
    self.uuid = SecureRandom.uuid
  end
  
end