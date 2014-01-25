class AddInitializationFlagToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.boolean :needs_initialization
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :needs_initialization
    end
  end
end
