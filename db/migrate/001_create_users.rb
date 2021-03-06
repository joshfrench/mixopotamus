class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      
      # add app-specific columns:
      t.column :address,                   :text, :limit => 1023
      t.column :invite_count,              :int
      t.column :reset,                     :string, :limit => 40
    end
  end
  
  def self.down
    drop_table "users"
  end
end
