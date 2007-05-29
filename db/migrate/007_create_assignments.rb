class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.column :swapset_id, :int
      t.column :user_id, :int
      t.column :position, :int
    end
  end

  def self.down
    drop_table :assignments
  end
end
