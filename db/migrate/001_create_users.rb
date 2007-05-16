class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
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
      t.column :invites,                   :int
    end

    User.create(:password => 'test', 
                :password_confirmation => 'test',
                :login => "Josh F", 
                :address => "155 23rd St\nBrooklyn, NY\n11232", 
                :email => "josh@vitamin-j.com")

  end
  
  def self.down
    drop_table "users"
  end
end
