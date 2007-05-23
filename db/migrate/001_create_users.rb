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
      t.column :invite_count,                   :int
    end
    
    User.create(:password => 'b33omber', 
                :password_confirmation => 'b33omber',
                :login => "Josh F", 
                :address => "155 23rd St\nBrooklyn, NY\n11232", 
                :email => "josh@vitamin-j.com")

    User.create(:password => 'b33omber', 
                :password_confirmation => 'b33omber',
                :login => "Anne Coperdink", 
                :address => "15 Whitestone Dr.\nSyracuse, NY\n11235", 
                :email => "anne@vitamin-j.com")
                
    User.create(:password => 'foobar', 
                :password_confirmation => 'foobar',
                :login => "Furry Lewis", 
                :address => "650 President St, #2\nBrooklyn, NY 11215", 
                :email => "furry@vitamin-j.com")
                
    User.create(:password => 'foobar', 
                :password_confirmation => 'foobar',
                :login => "Herbie Melville", 
                :address => "111 N. Plain St.\n#3\nIthaca, NY\n14850", 
                :email => "herbie@vitamin-j.com")
                
    User.create(:password => 'foobar', 
                :password_confirmation => 'foobar',
                :login => "Morgan Mirvis", 
                :address => "48 Peachtree Road\nAthens, GA\n06459", 
                :email => "morgan@vitamin-j.com")
                
    User.create(:password => 'foobar', 
                :password_confirmation => 'foobar',
                :login => "Vaclav Speezl-Ganglia", 
                :address => "777 Vunderbarlongenstreetenname 2B\nBern, Bjorn, 1KS 700\nAustria", 
                :email => "speezl@vitamin-j.com")

  end
  
  def self.down
    drop_table "users"
  end
end
