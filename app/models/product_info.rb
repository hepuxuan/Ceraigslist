# coding: UTF-8
class ProductInfo < ActiveRecord::Base
  belongs_to :user
  has_many :assets
  validates_presence_of :post_date, :title, :body, :source
  attr_accessible :assets_attributes, :post_date, :title, :body, :price, :address, :user_id, :state, :city, :tag_list, :uri, :source, :product_id
  acts_as_taggable
  accepts_nested_attributes_for :assets

  LOCAL = 0
  CRAGLIST = 1
end