class CreateTransfers < ActiveRecord::Migration
  def self.up
    create_table :transfers do |t|
      t.integer :origin_account_id
      t.integer :destination_account_id
      t.string :message
      t.integer :ammount
      t.timestamps
    end
  end

  def self.down
    drop_table :transfers
  end
end
