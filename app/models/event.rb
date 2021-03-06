require 'date'

class Event < ActiveRecord::Base
  has_many :participants
  has_many :users, through: :participants
  has_many :items
  has_many :payments, through: :items
  before_save :escape_tag

  validates :name, presence: true,  length: { maximum: 40 }

  validates :memo, presence: false, length: { maximum: 40 }

  default_scope -> { order('id DESC') }

  def formatted_date
    DateTime.parse(date.to_s).strftime('%Y/%m/%d').to_s if date
  end

  private

  def escape_tag
    tags = {
      '<' => '&lt;',
      '>' => '&gt;' }
    tags.each do |key, val|
      name.gsub!(key, val)
      memo.gsub!(key, val)
    end
  end
end
