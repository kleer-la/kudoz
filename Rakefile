require File.expand_path('../config/boot.rb', __FILE__)
require 'padrino-mailer'
require 'bundler/setup'
require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:activerecord)
PadrinoTasks.init

require_relative './app/helpers/notification_helper'

task :notify_transfers do
  
  Transfer.find_all_by_notified(false).each do |transfer|
    begin
      NotificationHelper.notify_transfer(transfer, nil)
      
      transfer.notified = true
      transfer.save!
      
      puts "Transfer #{transfer} notified."
    rescue Exception => e
      puts e.message
    end
  end
  
end