class CreateSwapsets < ActiveRecord::Migration
  def self.up
    create_table :swapsets do |t|
      t.column :name, :string
      t.column :swap_id, :int
    end
    
    Swapset.create
  end

  def self.down
    drop_table :swapsets
  end
end
