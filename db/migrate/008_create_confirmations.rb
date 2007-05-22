class CreateConfirmations < ActiveRecord::Migration
  def self.up
    create_table :confirmations do |t|
      t.column  :from_user,     :int
      t.column  :to_user,       :int
      t.column  :swapset_id,  :int
    end
  end

  def self.down
    drop_table :confirmations
  end
end
