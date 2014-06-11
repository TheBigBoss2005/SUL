class Payment < ActiveRecord::Base
  belongs_to :participants
  belongs_to :items
  validates :participant_id, presence: true
  validates :item_id, presence: true
  validates :price, presence: true
end
