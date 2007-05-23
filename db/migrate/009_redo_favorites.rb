class RedoFavorites < ActiveRecord::Migration
  def self.up
    drop_table :favorites
    create_table :favorites do |t|
      t.column :from_user, :int
      t.column :assignment_id, :int
    end
  end

  def self.down
    drop_table :favorites
    create_table :favorites do |t|
      t.column :from_user, :int
      t.column :to_user, :int
      t.column :swapset_id, :int
    end
  end
end
