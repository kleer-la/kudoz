class AddTwitterToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :twitter
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :twitter
    end
  end
end
