class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :payments
  before_save :escape_tag

  validates :memo, presence: true, length: { maximum: 20 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validates :user_id, presence: true
  validates :event_id, presence: true

  default_scope -> { order('id DESC') }

  private

  def escape_tag
    tags = {
      '<' => '&lt;',
      '>' => '&gt;' }
    tags.each do |key, val|
      memo.gsub!(key , val)
    end
  end
end
