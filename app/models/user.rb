class User < ActiveRecord::Base
  has_many :participants
  has_many :items
  before_save :escape_tag

  validates :name, presence: true, length: { maximum: 20 }

  private

  def escape_tag
    name.gsub!('<', '&lt;')
    name.gsub!('>', '&gt;')
  end
end
