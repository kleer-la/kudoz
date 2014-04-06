require 'active_record'

require_relative '../../models/account'
require_relative '../../models/feedback_cycle'
require_relative '../../models/feedback_cycle_position'
require_relative '../../models/invite'
require_relative '../../models/team'
require_relative '../../models/transfer'
require_relative '../../models/user'


ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
#ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "db/test.db"

ActiveRecord::Migrator.up "db/migrate"

load "db/schema.rb"

# RSpec.configure do |config|
#   config.around do |example|
#     ActiveRecord::Base.transaction do
#       example.run
#       raise ActiveRecord::Rollback
#     end
#   end
# end
