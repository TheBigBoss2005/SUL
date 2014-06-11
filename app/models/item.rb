class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :payments

  FORMAT = /\A[ \-_\/\w\d\p{Han}\p{Hiragana}\p{Katakana}\u3000\u30fc]+\z/
  validates :memo, presence: true, length: { maximum: 20 }, format: { with: FORMAT }

  validates :user_id, presence: true
  validates :event_id, presence: true
end
