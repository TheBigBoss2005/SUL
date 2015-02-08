class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :login
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :participants
  has_many :events, through: :participants
  has_many :items
  before_save :escape_tag

  validates :name, presence: true, length: { maximum: 20 }
  validates :login_id,
            presence: { message: 'は入力が必須です' },
            length: { maximum: 20, message: 'は20文字以内で入力して下さい' },
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-z0-9_]+\z/i, message: 'ログインIDは半角英数字_で入力して下さい' }

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['lower(login_id) = :value OR lower(email) = :value', { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  private

  def escape_tag
    tags = {
      '<' => '&lt;',
      '>' => '&gt;' }
    tags.each do |key, val|
      name.gsub!(key, val)
    end
  end
end
