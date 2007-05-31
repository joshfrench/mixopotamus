# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 9) do

  create_table "assignments", :force => true do |t|
    t.column "swapset_id", :integer
    t.column "user_id",    :integer
    t.column "position",   :integer
  end

  create_table "confirmations", :force => true do |t|
    t.column "from_user",     :integer
    t.column "assignment_id", :integer
    t.column "created_at",    :datetime
  end

  create_table "emails", :force => true do |t|
    t.column "from",              :string
    t.column "to",                :string
    t.column "last_send_attempt", :integer,  :default => 0
    t.column "mail",              :text
    t.column "created_at",        :datetime
  end

  create_table "favorites", :force => true do |t|
    t.column "from_user",     :integer
    t.column "assignment_id", :integer
  end

  create_table "invites", :force => true do |t|
    t.column "uuid",        :string
    t.column "from_user",   :integer
    t.column "to_email",    :string
    t.column "status",      :string
    t.column "created_at",  :datetime
    t.column "accepted_at", :datetime
    t.column "accepted_by", :integer
  end

  create_table "registrations", :force => true do |t|
    t.column "swap_id",    :integer
    t.column "user_id",    :integer
    t.column "double",     :boolean
    t.column "created_at", :datetime
    t.column "position",   :integer
  end

  create_table "swaps", :force => true do |t|
    t.column "deadline", :datetime
    t.column "position", :integer
  end

  create_table "swapsets", :force => true do |t|
    t.column "name",    :string
    t.column "swap_id", :integer
  end

  create_table "users", :force => true do |t|
    t.column "login",                     :string
    t.column "email",                     :string
    t.column "crypted_password",          :string,   :limit => 40
    t.column "salt",                      :string,   :limit => 40
    t.column "created_at",                :datetime
    t.column "updated_at",                :datetime
    t.column "remember_token",            :string
    t.column "remember_token_expires_at", :datetime
    t.column "address",                   :text,     :limit => 1023
    t.column "invite_count",              :integer
    t.column "reset",                     :string,   :limit => 40
  end

end
