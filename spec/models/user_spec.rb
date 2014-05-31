require 'spec_helper'

describe User do
  describe 'user名が１０文字以内であること' do
    user = User.new
    user.name = 'hogehogehogehoge'
    user.hoge = 'hogehogehogehoge'
    expect(user.save).to be_true
  end
end
