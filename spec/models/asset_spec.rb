# coding: UTF-8
require 'spec_helper'

describe Asset do
  it 'belongs to a product_info' do
    reflection = Asset.reflect_on_association(:product_info)
    expect(reflection.name).not_to eq(nil)
    expect(reflection.macro).to eq(:belongs_to)
  end
end