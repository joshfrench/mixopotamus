class CreateSwapsets < ActiveRecord::Migration
  def self.up
    create_table :swapsets do |t|
      t.column :name, :string
      t.column :swap_id, :int
    end
    
    Swapset.create(:swap_id => 1)
  end

  def self.down
    drop_table :swapsets
  end
end
