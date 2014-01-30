class AddKudozioTheGreat < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.boolean :is_kudozio
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :is_kudozio
    end
  end
end
