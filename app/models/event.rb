require 'date'

class Event < ActiveRecord::Base
  has_many :participants
  has_many :items
  before_save :escape_tag

  validates :name, presence: true,  length: { maximum: 40 }

  validates :memo, presence: false, length: { maximum: 40 }

  def formatted_date
    if date.nil?
      return nil
    else
      return DateTime.parse(date.to_s).strftime('%Y/%m/%d').to_s
    end
  end

  private

  def escape_tag
    tags = {
      '<' => '&lt;',
      '>' => '&gt;' }
    tags.each do |key, val|
      name.gsub!(key , val)
      memo.gsub!(key , val)
    end
  end
end
