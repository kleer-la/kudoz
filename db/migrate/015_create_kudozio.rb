class CreateKudozio < ActiveRecord::Migration
  def self.up
    kudozio = User.where( "is_kudozio = ?", true ).first
    
    if kudozio.nil?
      User.create( fname: "Kudozio", lname: "The Great", accounts: [ Account.create( balance: 0 ) ], image_url: "/img/kudozio/avatar.png", is_kudozio: true )
    end
    
  end

  def self.down
    kudozio = User.where( "is_kudozio = ?", true ).first
    kudozio.destroy
  end
end
