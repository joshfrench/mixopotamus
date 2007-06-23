class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.column :uuid, :string, :length => 32
      t.column :from_user, :int
      t.column :to_email, :string, :length => 255
      t.column :message, :text, :length => 500
      t.column :status, :string
      t.column :created_at, :datetime
      t.column :accepted_at, :datetime
      t.column :accepted_by, :int
    end
  end

  def self.down
    drop_table :invites
  end
end
