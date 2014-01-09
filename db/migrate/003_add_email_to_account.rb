class AddEmailToAccount < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.string :email
    end
  end

  def self.down
    change_table :accounts do |t|
      t.remove :email
    end
  end
end
