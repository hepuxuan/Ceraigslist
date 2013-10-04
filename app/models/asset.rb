# coding: UTF-8
class Asset < ActiveRecord::Base
  belongs_to :product_info
  attr_accessible :image, :crag_thumb_uri, :crag_uri, :product_info_id
  has_attached_file :image, :styles => {:thumb => "50x50>" }
  validates_attachment_size :image, less_than: 5.megabytes
end