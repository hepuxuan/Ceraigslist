# coding: UTF-8
require 'spec_helper'

describe ProductInfo do
  it 'has many assets' do
    reflection = ProductInfo.reflect_on_association(:assets)
    expect(reflection.name).not_to eq(nil)
    expect(reflection.macro).to eq(:has_many)
  end

  it 'belongs to a user' do
    reflection = ProductInfo.reflect_on_association(:user)
    expect(reflection.name).not_to eq(nil)
    expect(reflection.macro).to eq(:belongs_to)
  end
end