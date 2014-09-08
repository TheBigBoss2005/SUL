class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :payments
  before_save :escape_tag

  validates :memo, presence: true, length: { maximum: 20 }

  validates :user_id, presence: true
  validates :event_id, presence: true

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