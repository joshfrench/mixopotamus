require 'digest/sha1'
class AuthenticatedUser < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  set_table_name :users
  
  attr_accessor :password

  validates_length_of       :login,    :within => 3..40,
                            :message => "Name should be between 3 and 40 characters."
  validates_presence_of     :login, :message => "Name is blank."
  validates_presence_of     :password_confirmation,
                            :message => "Password confirmation is blank.",
                            :if => :password_required?
  validates_presence_of     :address, :message => "Address is blank."
  validates_length_of       :password, :within => 4..40, 
                            :message => "Password should be between 4 and 40 characters.",
                            :if => :password_required?
  validates_presence_of     :password,  
                            :message => "Password is blank.",
                            :if => :password_required?
  validates_confirmation_of :password,
                            :message => "Password doesn't match confirmation",
                            :if => :password_required?
  validates_length_of       :email,    :within => 3..100,
                            :message => "That's not a valid email."
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                            :message => "That's not a valid email."
  validates_uniqueness_of   :email, :case_sensitive => false,
                            :message => "That email is already in use by someone else."
  before_save :encrypt_password

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find_by_email(email) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 1.year.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end

end
