class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.string :image_url
      t.string :uid
      t.string :provider
      t.timestamps
    end
    
    change_table :accounts do |t|
      t.integer :user_id
    end
    
  end

  def self.down
    drop_table :users
    
    change_table :accounts do |t|
      t.remove :user_id
    end
    
  end
end
