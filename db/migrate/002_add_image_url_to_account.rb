class AddImageUrlToAccount < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.string :image_url
    end
  end

  def self.down
    change_table :accounts do |t|
      t.remove :image_url
    end
  end
end
