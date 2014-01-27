class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer :team_id
      t.integer :user_id
      t.string :uuid
      t.string :guest_email
      t.string :message
      t.boolean :acepted
      t.timestamps
    end
  end

  def self.down
    drop_table :invites
  end
end
