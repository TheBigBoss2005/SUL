class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :payments
  validates :user_id, presence: true
  validates :event_id, presence: true
end
