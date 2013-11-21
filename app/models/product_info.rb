# coding: UTF-8
class ProductInfo < ActiveRecord::Base
  belongs_to :user
  has_many :assets
  validates_presence_of :post_date, :title, :body, :source
  attr_accessible :assets_attributes, :post_date, :title, :body, :price, :address, :user_id, :state, :city, :tag_list, :uri, :source, :product_id, :latitude, :longitude
  acts_as_taggable
  accepts_nested_attributes_for :assets

  LOCAL = 0
  CRAGLIST = 1
  before_save do |product_info|
  	if product_info.address.present?
      geo_loc = Geokit::Geocoders::GeonamesGeocoder.geocode product_info.address
      product_info.latitude = geo_loc.lat
      product_info.longitude = geo_loc.lng
    end
  end
end