class Payment < ActiveRecord::Base
  belongs_to :participant
  belongs_to :item
  validates :participant_id, presence: true
  validates :item_id, presence: true
  validates :price, presence: true
end
