# coding: UTF-8
require 'spec_helper'

describe User do
  it 'has many a product_info' do
    reflection = User.reflect_on_association(:product_info)
    expect(reflection.name).not_to eq(nil)
    expect(reflection.macro).to eq(:has_many)
  end

  it 'returns false when trying to save a user with invalid email' do
    user = User.new(name: 'puxuan he', email: 'invalid', password: 'valid', password_confirmation: 'valid', address: '3810 85th ter aptc', state: 'MO', city: 'Knasas city')
    expect(user.save).to eq(false)
  end

  it 'returns true when trying to save a user with valid email' do
    user = User.new(name: 'puxuan he', email: 'puxuan.he@cerner.com', password: 'valid', password_confirmation: 'valid', address: '3810 85th ter aptc', state: 'MO', city: 'Knasas city')
    expect(user.save).to eq(true)
  end

  it 'returns false when trying to save a user with different password and password_confirmation' do
    user = User.new(name: 'puxuan he', email: 'puxuan.he@cerner.com', password: 'valid', password_confirmation: 'invalid', address: '3810 85th ter aptc', state: 'MO', city: 'Knasas city')
    expect(user.save).to eq(false)
  end

  it 'convert email to lower case when trying to save a user' do
    user = User.new(name: 'puxuan he', email: 'PUXUAN.HE@CERNER.COM', password: 'valid', password_confirmation: 'valid', address: '3810 85th ter aptc', state: 'MO', city: 'Knasas city')
    user.save
    expect(user.email).to eq('puxuan.he@cerner.com')
  end
end