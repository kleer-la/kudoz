class CreateNotifiedFieldInTransfers < ActiveRecord::Migration
  def self.up
    change_table :transfers do |t|
      t.boolean :notified, default: false
    end
  end

  def self.down
    change_table :transfers do |t|
      t.remove :notified
    end
  end
end
