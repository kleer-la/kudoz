class AddKudozioTheGreat < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.boolean :is_kudozio
    end
    
    User.create( fname: "Kudozio", lname: "The Great", accounts: [ Account.create( balance: 0 ) ], image_url: "/img/kudozio/avatar.png", is_kudozio: true )
    
  end

  def self.down
    change_table :users do |t|
      t.remove :is_kudozio
    end
  end
end
