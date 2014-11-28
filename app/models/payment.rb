class Payment < ActiveRecord::Base
  belongs_to :participant
  belongs_to :item
  validates :participant_id, presence: true
  validates :item_id, presence: true
  validates :price, presence: true

  default_scope -> { order('item_id DESC, participant_id ASC') }

  def finished
    update_attribute(:status, true)
  end
end
