class User < ActiveRecord::Base
  has_many :participants
  has_many :events, through: :participants
  has_many :items
  before_save :escape_tag

  validates :name, presence: true, length: { maximum: 20 }

  private

  def escape_tag
    tags = {
      '<' => '&lt;',
      '>' => '&gt;' }
    tags.each do |key, val|
      name.gsub!(key , val)
    end
  end
end
