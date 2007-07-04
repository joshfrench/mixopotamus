class CreateSwaps < ActiveRecord::Migration
  def self.up
    create_table :swaps do |t|
      t.column :deadline, :datetime
      t.column :position, :int
    end
  end

  def self.down
    drop_table :swaps
  end
end
