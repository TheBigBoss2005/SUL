require 'date'

class Event < ActiveRecord::Base
  has_many :participants
  has_many :items
  before_save :escape_tag

  validates :name, presence: true,  length: { maximum: 40 }

  validates :memo, presence: false, length: { maximum: 40 }

  private

  def escape_tag
    name.gsub!('<', '&lt;')
    name.gsub!('>', '&gt;')
    memo.gsub!('<', '&lt;')
    memo.gsub!('>', '&gt;')
  end

  def conv_datetime
    DateTime.strptime(date)
  end
end
