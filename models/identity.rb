class Identity
  include DataMapper::Resource
  property :id,               Serial

  property :email,            String, :length => 127
  property :crypted_password, String, :length => 60

  property :role,             String

  property :name, String

  validates_presence_of      :email, :role, :name
  validates_format_of        :email,    :with => :email_address
  validates_uniqueness_of    :email
  validates_format_of        :role,     :with => /[A-Za-z]/

  validates_presence_of      :crypted_password

  property :deleted_at,      ParanoidDateTime
  timestamps :at

  before :save do |identity|
    identity.email = identity.email.downcase
  end

  def password= password
    self.crypted_password = BCrypt::Password.create password
  end

  def self.authenticate(email, password)
    instance = first(:email => email.downcase)
    return false unless instance
    BCrypt::Password.new(instance.crypted_password) == password ? instance : nil
  end
end
