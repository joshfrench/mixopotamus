class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites do |t|
      t.column :from_user, :int
      t.column :assignment_id, :int
    end
  end

  def self.down
    drop_table :favorites
  end
end
