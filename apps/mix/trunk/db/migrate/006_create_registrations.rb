class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.column :swap_id, :int
      t.column :user_id, :int
      t.column :double, :boolean
      t.column :created_at, :datetime
      t.column :position, :int
    end
  end

  def self.down
    drop_table :registrations
  end
end
