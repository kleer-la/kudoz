require File.expand_path('../config/boot.rb', __FILE__)
require 'padrino-mailer'
require 'bundler/setup'
require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:activerecord)
PadrinoTasks.init

require_relative './app/helpers/notification_helper'

task :notify_transfers do
  transfer = Transfer.new do |t|
    t.ammount = 1
    t.message = 'Hola'
    t.origin = Account.find_by_id(4)
    t.destination = Account.find_by_id(2)
  end
  NotificationHelper.notify_transfer(transfer, nil)
end