class CreateConfirmations < ActiveRecord::Migration
  def self.up
    create_table :confirmations do |t|
      t.column  :from_user,     :int
      t.column  :assignment_id, :int
      t.column  :created_at,    :datetime
    end
  end

  def self.down
    drop_table :confirmations
  end
end
