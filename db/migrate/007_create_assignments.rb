class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.column :swapset_id, :int
      t.column :user_id, :int
      t.column :position, :int
    end
    
    (1..6).each do |i|
      Assignment.create(:swapset_id => 1, :user_id => i)
    end
  end

  def self.down
    drop_table :assignments
  end
end
