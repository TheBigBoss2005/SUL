class Event < ActiveRecord::Base
  has_many :participants
  has_many :items

  FORMAT = /\A[ \-_\/\w\d\p{Han}\p{Hiragana}\p{Katakana}\u3000\u30fc]+\z/
  validates :name, presence: true,  length: { maximum: 40 }, format: { with: FORMAT }

  validates :memo, presence: false, length: { maximum: 40 }, format: { with: FORMAT }
end
