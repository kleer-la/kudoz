class RemoveUserInformationFromAccount < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.remove :name
      t.remove :email
      t.remove :uid
      t.remove :provider
      t.remove :image_url
    end
  end

  def self.down
    change_table :accounts do |t|
      t.string :name
      t.string :email
      t.string :uid
      t.string :provider
      t.string :image_url
    end
  end
end
